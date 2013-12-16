class KarmasController < ApplicationController
  authorize_resource

  def index
    @karmas = Karma.where karma_group_id: params[:karma_group_id]
    respond_to do |format|
      format.html { render 'index', layout: false }
    end
  end
  
  def new
    @karma = Karma.new params[:karma]
    respond_to do |format|
      format.js { render 'show_form' }
    end
  end

  def edit
    @karma = Karma.find params[:id]
    respond_to do |format|
      format.js { render 'show_form' }
    end
  end

  def create
    @karma = Karma.new params[:karma]
    respond_to do |format|
      if @karma.save
        format.js
      else
        format.js { render 'show_form' }
      end
    end
  end

  def update
    @karma = Karma.find params[:id]
    respond_to do |format|
      if @karma.update_attributes params[:karma]
        format.js
      else
        format.js { render 'show_form' }
      end
    end
  end

  def destroy
    @karma = Karma.find params[:id]
    @karma.destroy
    respond_to do |format|
      format.js
    end
  end

  def group
    @karma1 = Karma.find params[:id1]
    @karma2 = Karma.find params[:id2]
    respond_to do |format|
      if @karma1.group_with @karma2
        format.js
      else
        format.js
      end
    end
  end

  def ungroup
    @karma = Karma.find params[:id]
    @old_karma_group_id = @karma.karma_group_id
    respond_to do |format|
      if @karma.ungroup
        @old_karma_group = KarmaGroup.where(id: @old_karma_group_id).first
        format.js
      else
        format.js
      end
    end
  end

  def addtogroup
    @karma = Karma.find params[:id]
    @karma_group = KarmaGroup.find params[:karma_group_id]
    @old_karma_group = KarmaGroup.find(@karma.karma_group_id) if @karma.karma_group.present?
    respond_to do |format|
      if @karma.add_to_group @karma_group
        format.js
      else
        format.js
      end
    end
  end

end
