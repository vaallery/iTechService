class SubstitutePhonesController < ApplicationController
  skip_after_action :verify_authorized
  respond_to :html

  def index
    respond_to do |format|
      run SubstitutePhone::Index do
        format.html { return render_cell SubstitutePhone::Cell::Index }
        format.js { return }
      end
      format.any(:html, :js) { failed }
    end
  end

  def show
    run SubstitutePhone::Show do
      return render_cell SubstitutePhone::Cell::Show
    end
    failed
  end

  def new
    run SubstitutePhone::Create::Present do
      return render_form
    end
    failed
  end

  def create
    run SubstitutePhone::Create do
      return redirect_to operation_model, notice: operation_message
    end
    render_form
  end

  def edit
    run SubstitutePhone::Update::Present do
      return render_form
    end
    failed
  end

  def update
    run SubstitutePhone::Update do
      return redirect_to_index notice: operation_message
    end
    render_form
  end

  def destroy
    run SubstitutePhone::Destroy do
      return redirect_to substitute_phones_url, notice: t('substitute_phones.destroyed')
    end
    failed
  end

  private

  def render_form
    render_cell SubstitutePhone::Cell::Form
  end
end
