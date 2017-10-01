class SubstitutePhonesController < ApplicationController
  respond_to :html

  def index
    respond_to :html, :js
    run SubstitutePhone::Index do
      return
    end
    failed
  end

  def show
    run SubstitutePhone::Show do
      return render_cell SubstitutePhone::Cell::Show
    end
    failed
  end

  def new
    run SubstitutePhone::Create::Present do
      return
    end
    failed
  end

  def create
    run SubstitutePhone::Create do
      return redirect_to operation_model, notice: operation_message
    end
    render 'new'
  end

  def edit
    run SubstitutePhone::Update::Present do
      return render 'edit'
    end
    failed
  end

  def update
    run SubstitutePhone::Update do
      return redirect_to_index notice: operation_message
    end
    render 'edit'
  end

  def destroy
    run SubstitutePhone::Destroy do
      return redirect_to substitute_phones_url, notice: t('substitute_phones.destroyed')
    end
    failed
  end
end
