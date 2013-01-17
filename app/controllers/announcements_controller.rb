class AnnouncementsController < ApplicationController

  load_and_authorize_resource

  def index
    @announcements = Announcement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @announcements }
    end
  end

  def show
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @announcement }
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
        format.html { redirect_to @announcement, notice: 'Announcement was successfully created.' }
        format.json { render json: @announcement, status: :created, location: @announcement }
      else
        format.html { render action: "new" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      if @announcement.update_attributes(params[:announcement])
        format.html { redirect_to @announcement, notice: 'Announcement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
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

  def call_help
    @announcement = current_user.needs_help? ? nil : current_user.announcements.create
  end

  def cancel_help
    if (@announcement = current_user.announcements.active_help.first).present?
      @announcement.update_attribute :active, false
    end
  end

end
