class WikiPagesController < ApplicationController

  acts_as_wiki_pages_controller

  private

  def show_allowed?
    can? :read, WikiPage
  end

  def history_allowed?
    can? :manage, WikiPage
  end

  def edit_allowed?
    can? :manage, WikiPage
  end

  #def current_user
  #  current_user
  #end

end
