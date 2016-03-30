# encoding: utf-8

class Page < ActiveRecord::Base
  include PagesCore::HumanizableParam
  include PagesCore::PageTree
  include PagesCore::PathablePage
  include PagesCore::SearchablePage
  include PagesCore::Sweepable
  include PagesCore::Taggable
  include PagesCore::Templateable

  belongs_to :author, class_name: "User", foreign_key: :user_id

  has_and_belongs_to_many :categories, join_table: "pages_categories"
  has_many :page_paths, dependent: :destroy

  belongs_to_image :image
  belongs_to_image :meta_image, class_name: "Image"

  has_many :page_images, -> { order("position") }

  has_many :images,
           -> { where("`page_images`.`primary` = ?", false).order("position") },
           through: :page_images

  has_many :comments,
           class_name: "PageComment",
           dependent: :destroy

  has_many :page_files,
           -> { order("position ASC") },
           class_name: "PageFile",
           dependent: :destroy

  acts_as_list scope: :parent_page

  localizable do
    attribute :name
    attribute :body
    attribute :excerpt
    attribute :headline
    attribute :boxout

    attribute :path_segment
    attribute :meta_title
    attribute :meta_description
    attribute :open_graph_title
    attribute :open_graph_description

    dictionary -> { PagesCore::Templates::TemplateConfiguration.all_blocks }
  end

  validates(:redirect_to,
            format: { with: %r{\A(/|https?://).+\z},
                      allow_nil: true,
                      allow_blank: true })

  validates(:unique_name,
            format: { with: /\A[\w\d_\-]+\z/,
                      allow_nil: true,
                      allow_blank: true },
            uniqueness: { allow_nil: true, allow_blank: true })

  validates :template, presence: true
  validates :published_at, presence: true

  before_validation :published_at
  before_validation :set_autopublish
  after_save :ensure_page_images_contains_primary_image
  after_save :queue_autopublisher
  after_save ThinkingSphinx::RealTime.callback_for(:page)
  after_save :check_list_position

  scope :by_date,    -> { order("published_at DESC") }
  scope :published,  -> { where(status: 2, autopublish: false) }
  scope :visible,    -> { where("status < 4") }
  scope :news_pages, -> { visible.where(news_page: true) }
  scope :pinned,     -> { where(pinned: true) }

  class << self
    def archive_finder
      PagesCore::ArchiveFinder.new(all, timestamp: :published_at)
    end

    # Find all published and feed enabled pages
    def enabled_feeds(locale, options = {})
      conditions = (options[:include_hidden]) ? "status IN (2,3)" : "status = 2"
      Page.where(feed_enabled: true).where(conditions).localized(locale)
    end

    def status_labels
      {
        0 => "Draft",
        1 => "Reviewed",
        2 => "Published",
        3 => "Hidden",
        4 => "Deleted"
      }
    end

    def order_by_tags(tags)
      joins(
        "LEFT JOIN taggings ON taggings.taggable_id = pages.id AND " \
          "taggable_type = #{ActiveRecord::Base.connection.quote('Page')}",
        "LEFT JOIN tags ON tags.id = taggings.tag_id AND tags.id IN (" +
          tags.map(&:id).join(",") +
          ")"
      )
        .group("pages.id, localizations.id")
        .reorder("COUNT(tags.id) DESC, position ASC")
    end
  end

  def comments_closed_after_time?
    if PagesCore.config.close_comments_after.nil?
      false
    else
      (Time.now.utc - published_at) > PagesCore.config.close_comments_after
    end
  end

  def comments_allowed?
    if comments_closed_after_time?
      false
    else
      self[:comments_allowed]
    end
  end

  def empty?
    !body? && !excerpt?
  end
  alias blank? empty?

  def excerpt_or_body
    excerpt? ? excerpt : body
  end

  def extended?
    excerpt? && body?
  end

  def image
    super.try { |i| i.localize(locale) }
  end

  def images
    super.in_locale(locale)
  end

  def page_images
    super.in_locale(locale)
  end

  def files
    page_files.in_locale(locale)
  end

  def headline_or_name
    headline? ? headline : name
  end

  # Does this page have an image?
  def image?
    image_id?
  end

  def move(parent:, position:)
    Page.transaction do
      update(parent: parent) unless self.parent == parent
      insert_at(position)
    end
  end

  # Get subpages
  def pages(_options = nil)
    if locale?
      subpages.published.localized(locale)
    else
      subpages.published
    end
  end

  def subpages
    children.order(content_order)
  end

  # Return the status of the page as a string
  def status_label
    self.class.status_labels[status]
  end

  def flag_as_deleted!
    update(status: 4)
  end

  # Get publication date, which defaults to the creation date
  def published_at
    self[:published_at] ||= if created_at?
                              created_at
                            else
                              Time.now.utc
                            end
  end

  # Returns boolean true if page has a valid redirect
  def redirects?
    redirect_to?
  end

  def redirect_path(params = {})
    path = redirect_to.dup
    if path.start_with? "/"
      params.each do |key, value|
        unless value.is_a?(String) || value.is_a?(Symbol)
          raise "redirect_url param must be a string or a symbol"
        end
        path.gsub!("/:#{key}", "/#{value}")
      end
    end
    path
  end

  # Returns true if this page's children is reorderable
  def reorderable_children?
    !news_page?
  end

  # Returns true if this page is reorderable
  def reorderable?
    !parent || !parent.news_page?
  end

  def draft?
    status == 0
  end

  def reviewed?
    status == 1
  end

  def published?
    status == 2 && !autopublish?
  end

  def hidden?
    status == 3
  end

  def deleted?
    status == 4
  end

  def to_param
    humanized_param(name)
  end

  def content_order
    if news_page?
      "pages.pinned DESC, published_at DESC"
    else
      "position ASC"
    end
  end

  private

  def check_list_position
    if deleted?
      remove_from_list
    elsif !position?
      assume_bottom_position
    end
  end

  def ensure_page_images_contains_primary_image
    return if !image_id? || !image_id_changed?
    page_image = page_images.find_by(image_id: image_id)
    if page_image
      page_image.update(primary: true)
    else
      page_images.create(image_id: image_id, primary: true)
    end
  end

  def set_autopublish
    self.autopublish = published_at? && published_at > Time.now.utc
    true
  end

  def queue_autopublisher
    Autopublisher.queue! if autopublish?
  end
end
