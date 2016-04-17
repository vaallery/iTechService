class FavoriteLinksController < ApplicationController
  authorize_resource

  def index
    @favorite_links = current_user.favorite_links
    respond_to do |format|
      format.html
    end
  end

  def new
    @favorite_link = FavoriteLink.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @favorite_link = FavoriteLink.find params[:id]
    respond_to do |format|
      format.html
    end
  end

  def create
    @favorite_link = FavoriteLink.new favorite_link_params.merge(owner: current_user)
    respond_to do |format|
      if @favorite_link.save
        format.html { redirect_to favorite_links_path, notice: t('favorite_links.created') }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @favorite_link = FavoriteLink.find params[:id]
    respond_to do |format|
      if @favorite_link.update favorite_link_params
        format.html { redirect_to favorite_links_path, notice: t('favorite_links.updated') }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @favorite_link = FavoriteLink.find params[:id]
    @favorite_link.destroy

    respond_to do |format|
      format.html { redirect_to favorite_links_path, notice: t('favorite_links.destroyed') }
    end
  end

  private

  def favorite_link_params
    params.require(:favorite_link).permit(:name, :url)
  end
end
