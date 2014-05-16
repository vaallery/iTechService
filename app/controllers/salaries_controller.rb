class SalariesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :new]

  def index
    @salaries = Salary.search(params).page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @salaries }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @salary }
    end
  end

  def new
    @salary = Salary.new user_id: params[:user_id]
    @user = User.find_by_uid params[:user_id] if params[:user_id].present?

    respond_to do |format|
      format.html
      format.json { render json: @salary }
    end
  end

  def edit
  end

  def create
    respond_to do |format|
      if @salary.save
        format.html { redirect_back_or salaries_path, notice: t('salaries.created') }
        format.json { render json: @salary, status: :created, location: @salary }
      else
        format.html { render action: 'new' }
        format.json { render json: @salary.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @salary.update_attributes(params[:salary])
        format.html { redirect_back_or salaries_path, notice: t('salaries.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @salary.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @salary.destroy

    respond_to do |format|
      format.html { redirect_to salaries_url }
      format.json { head :no_content }
    end
  end

end
