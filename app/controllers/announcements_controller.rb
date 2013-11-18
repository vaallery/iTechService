class AnnouncementsController < ApplicationController
  authorize_resource

  def index
    if params[:actual].present?
      @announcements = Announcement.actual_for current_user
      render @announcements, layout: false
    else
      @announcements = Announcement.newest.page params[:page]
    end
  end

  def show
    @announcement = Announcement.find params[:id]

    respond_to do |format|
      format.js
    end
  end

  def new
    @announcement = Announcement.new

    respond_to do |format|
      format.html
      format.json { render json: @announcement }
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def create
    @announcement = Announcement.new(params[:announcement])

    respond_to do |format|
      if @announcement.save
        format.html { redirect_to announcements_path, notice: t('announcements.created') }
        format.json { render json: @announcement, status: :created, location: @announcement }
      else
        format.html { render action: 'new' }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      if @announcement.update_attributes(params[:announcement])
        format.html { redirect_to announcements_path, notice: t('announcements.updated') }
        format.json { render json: @announcement }
        format.js { render nothing: true }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
        format.js { render nothing: true }
      end
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to announcements_url }
      format.json { head :no_content }
    end
  end

  def make_announce
    if params[:kind] == 'for_coffee'
      @announcement = current_user.announcements.create kind: params[:kind], content: params[:content], active: true
    else
      @announcement = current_user.announced? ? nil : current_user.announcements.create(kind: params[:kind], active: true)
    end
  end

  def cancel_announce
    if (@announcements = current_user.announcements.active.where(kind: params[:kind])).any?
      @announcements.find_each do |announcement|
        announcement.update_attributes active: false
      end
    end
  end

  def close
    @announcement = Announcement.find params[:id]
    @announcement.exclude_recipient current_user
  end

  def close_all
    user = current_user
    user_announcements = user.addressed_announcements
    @announcement_ids = user_announcements.map { |a| a.id }
    user_announcements.find_each do |announcement|
      announcement.exclude_recipient(user)
    end
  end

end
