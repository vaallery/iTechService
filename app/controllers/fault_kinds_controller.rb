class FaultKindsController < ApplicationController
  authorize_resource

  def index
    @fault_kinds = FaultKind.all
    respond_to do |format|
      format.html
    end
  end

  def new
    form FaultKind::Create
    respond_to do |format|
      format.html
    end
  end

  def create
    respond_to do |format|
      run FaultKind::Create do |_|
        format.html { return redirect_to_index notice: t('fault_kinds.created') }
      end
      format.html { render :new }
    end
  end

  def edit
    form FaultKind::Update
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      run FaultKind::Update do |_|
        format.html { return redirect_to_index notice: t('fault_kinds.updated') }
      end
      format.html { render :edit }
    end
  end

  def destroy
    respond_to do |format|
      run FaultKind::Destroy do |_|
      end
      format.html { return redirect_to_index notice: t('fault_kinds.destroyed') }
    end
  end

  private

  def redirect_to_index(response_status={})
    redirect_to fault_kinds_path, response_status
  end
end