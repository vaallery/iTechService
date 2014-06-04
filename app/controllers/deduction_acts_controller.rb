class DeductionActsController < ApplicationController
  authorize_resource

  def index
    @deduction_acts = DeductionAct.search(params).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.js { render 'shared/index' }
      format.json { render json: @deduction_acts }
    end
  end

  def show
    @deduction_act = DeductionAct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deduction_act }
    end
  end

  def new
    @deduction_act = DeductionAct.new

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @deduction_act }
    end
  end

  def edit
    @deduction_act = DeductionAct.find(params[:id])

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @deduction_act }
    end
  end

  def create
    @deduction_act = DeductionAct.new(params[:deduction_act])

    respond_to do |format|
      if @deduction_act.save
        format.html { redirect_to @deduction_act, notice: t('deduction_acts.created') }
        format.json { render json: @deduction_act, status: :created, location: @deduction_act }
      else
        format.html { render 'form' }
        format.json { render json: @deduction_act.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @deduction_act = DeductionAct.find(params[:id])

    respond_to do |format|
      if @deduction_act.update_attributes(params[:deduction_act])
        format.html { redirect_to @deduction_act, notice: t('deduction_acts.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @deduction_act.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @deduction_act = DeductionAct.find(params[:id])
    @deduction_act.destroy

    respond_to do |format|
      format.html { redirect_to deduction_acts_url }
      format.json { head :no_content }
    end
  end

  def post
    @deduction_act = DeductionAct.find params[:id]

    respond_to do |format|
      if @deduction_act.post
        format.html { redirect_to @deduction_act, notice: t('documents.posted') }
      else
        flash.alert = @deduction_act.errors.full_messages
        format.html { redirect_to @deduction_act, error: t('documents.not_posted') }
      end
    end
  end

end
