# frozen_string_literal: true

class PagePolicy < Policy
  def index?
    true
  end

  def news?
    true
  end

  def calendar?
    index?
  end

  def deleted?
    index?
  end

  def new?
    user.role?(:pages)
  end

  def new_news?
    create?
  end

  def show?
    true
  end

  def edit?
    user.role?(:pages)
  end

  def move?
    edit?
  end

  def delete_meta_image?
    edit?
  end
end
