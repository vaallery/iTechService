class RevaluationActsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :new]

  def index
    @revaluation_acts = RevaluationAct.search(params).page(params[:page])

    respond_to do |format|
      format.html
      format.js { render 'shared/index' }
      format.json { render json: @revaluation_acts }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @revaluation_act }
    end
  end

  def new
    @revaluation_act = RevaluationAct.new params[:revaluation_act]

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @revaluation_act }
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @revaluation_act }
    end
  end

  def create
    respond_to do |format|
      if @revaluation_act.save
        format.html { redirect_to @revaluation_act, notice: t('revaluation_acts.created') }
        format.json { render json: @revaluation_act, status: :created, location: @revaluation_act }
      else
        format.html { render 'form' }
        format.json { render json: @revaluation_act.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @revaluation_act.update_attributes(params[:revaluation_act])
        format.html { redirect_to @revaluation_act, notice: t('revaluation_acts.updated') }
        format.json { head :no_content }
      else
        format.html { render 'form' }
        format.json { render json: @revaluation_act.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @revaluation_act.destroy

    respond_to do |format|
      format.html { redirect_to revaluation_acts_url }
      format.json { head :no_content }
    end
  end

  def post
    respond_to do |format|
      if @revaluation_act.post
        format.html { redirect_to @revaluation_act, notice: t('revaluation_acts.posted') }
      else
        format.html { redirect_to @revaluation_act, error: t('revaluation_acts.not_posted') }
      end
    end
  end

  def unpost
    respond_to do |format|
      if @revaluation_act.unpost
        format.html { redirect_to @revaluation_act, notice: t('revaluation_acts.unposted') }
      else
        format.html { redirect_to @revaluation_act, error: t('revaluation_acts.not_unposted') }
      end
    end
  end

end
