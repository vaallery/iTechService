class ResourcesController < ApplicationController
  before_filter :authenticate_user!
  skip_load_resource only: :index
  load_and_authorize_resource
  # helper_method :sort_column, :sort_direction

  def current_ability
    @current_ability ||= Ability.new current_user
  end
  
  private
    
  # def sort_column
  #   User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  # end

  # def sort_direction
  #   %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  # end
  
end