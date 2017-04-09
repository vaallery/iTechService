class SubstitutePhonesController < ApplicationController

  def index
    present SubstitutePhone::Index
  end

  def show
    present SubstitutePhone::Show
  end

  def new
    form SubstitutePhone::Create
  end

  def create
    run SubstitutePhone::Create do
      return redirect_to @substitute_phone, notice: t('substitue_phones.created')
    end
    render :new
  end

  def edit
    form SubstitutePhone::Update
  end

  def update
    run SubstitutePhone::Update do
      return redirect_to @substitute_phone, notice: t('substitue_phones.updated')
    end
    render :edit
  end

  def destroy
    run SubstitutePhone::Destroy
    redirect_to substitute_phones_url, notice: t('substitue_phones.created')
  end
end
