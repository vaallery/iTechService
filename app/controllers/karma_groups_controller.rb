class KarmaGroupsController < ApplicationController
  authorize_resource
  before_filter :convert_karma_ids, only: [:create]

  def index
    @karma_groups = Karma.where karma_group_id: params[:karma_group_id]
    respond_to do |format|
      format.html { render 'index', layout: false }
    end
  end

  def show
    @karma_group = KarmaGroup.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def create
    @karma_group = KarmaGroup.new params[:karma_group]
    respond_to do |format|
      if @karma_group.save
        format.js
      else
        format.js
      end
    end
  end

  def edit
    @karma_group = KarmaGroup.find(params[:id])
    @karma_group.build_bonus
    respond_to do |format|
      format.js { render 'shared/show_modal_form' }
    end
  end

  def update
    @karma_group = KarmaGroup.find params[:id]
    respond_to do |format|
      if @karma_group.update_attributes params[:karma_group]
        format.js
      else
        format.js { render 'shared/show_modal_form' }
      end
    end
  end

  private

  def convert_karma_ids
    params[:karma_group][:karma_ids] = params[:karma_group][:karma_ids].split(',') if params[:karma_group].present?
  end

end
