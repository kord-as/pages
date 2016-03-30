class Role < ActiveRecord::Base
  belongs_to :user
  validates :name,
            presence:   true,
            uniqueness: { scope: :user_id },
            inclusion:  { in: proc { Role.roles.map(&:name) } }

  class << self
    def define(name, description, default = false)
      if roles.map(&:name).include?(name.to_s)
        raise ArgumentError, "Tried to define role :#{role}, " \
          "but a role by that name already exists"
      else
        roles << OpenStruct.new(
          name: name.to_s,
          description: description,
          default: default
        )
      end
    end

    def roles
      @roles ||= default_roles
    end

    def names
      all.map(&:name)
    end

    protected

    def default_roles
      [
        OpenStruct.new(
          name: "users", description: "Can manage users", default: false
        ),
        OpenStruct.new(
          name: "pages", description: "Can manage pages", default: true
        )
      ]
    end
  end

  def name=(new_name)
    super(new_name.to_s)
  end

  def to_s
    name.humanize
  end
end
