class InstallmentPlansController < ApplicationController

  def index
    @installment_plans = InstallmentPlan.order('issued_at desc')

    respond_to do |format|
      format.html
      format.json { render json: @installment_plans }
    end
  end

  def show
    @installment_plan = InstallmentPlan.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @installment_plan }
    end
  end

  def new
    @installment_plan = InstallmentPlan.new

    respond_to do |format|
      format.html
      format.json { render json: @installment_plan }
    end
  end

  def edit
    @installment_plan = InstallmentPlan.find(params[:id])
  end

  def create
    @installment_plan = InstallmentPlan.new(params[:installment_plan])

    respond_to do |format|
      if @installment_plan.save
        format.html { redirect_to @installment_plan, notice: 'Installment plan was successfully created.' }
        format.json { render json: @installment_plan, status: :created, location: @installment_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @installment_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @installment_plan = InstallmentPlan.find(params[:id])

    respond_to do |format|
      if @installment_plan.update_attributes(params[:installment_plan])
        format.html { redirect_to @installment_plan, notice: 'Installment plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @installment_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @installment_plan = InstallmentPlan.find(params[:id])
    @installment_plan.destroy

    respond_to do |format|
      format.html { redirect_to installment_plans_url }
      format.json { head :no_content }
    end
  end
end
