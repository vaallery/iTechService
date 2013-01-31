class CommentsController < ApplicationController
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource
  skip_load_resource only: [:index]

  def index
    if (commentable_type = params[:commentable_type]).present? and
        (commentable_id = params[:commentable_id]).present?
      if commentable_type.constantize.respond_to? :find
        @commentable = commentable_type.constantize.find commentable_id
        @comments = @commentable.comments
      end
    else
      if params.has_key? :sort and params.has_key? :direction
        @comments = Comment.scoped.order 'comments.'+sort_column + ' ' + sort_direction
      else
        @comments = Comment.ordered.page params[:page]
      end
      @comments = @comments.page params[:page]
    end

    respond_to do |format|
      format.html
      format.json { render json: @comments }
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @comment }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: @comment }
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: t('comments.created') }
        format.json { render json: @comment, status: :created, location: @comment }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: t('comments.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  private

  def sort_column
    Comment.column_names.include?(params[:sort]) ? params[:sort] : ''
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

end
