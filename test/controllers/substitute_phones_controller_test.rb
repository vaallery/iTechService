require 'test_helper'

class SubstitutePhonesControllerTest < IntegrationTest
  # setup { sign_in current_user }

  def test_index
    create :substitute_phone
    get :index
    assert_response :success
    assert_not_nil assigns(:substitute_phones)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    params = attributes_for :substitute_phone
    assert_difference("SubstitutePhone.count") do
      post :create, substitute_phone: params
    end

    assert_redirected_to substitute_phone_path(assigns(:substitute_phone))
  end

  def test_show
    get :show, id: substitute_phone
    assert_response :success
  end

  def test_edit
    get :edit, id: substitute_phone
    assert_response :success
  end

  def test_update
    put :update, id: substitute_phone, substitute_phone: { condition: 'Condition' }
    assert_redirected_to substitute_phone_path(assigns(:substitute_phone))
  end

  def test_destroy
    assert_difference("SubstitutePhone.count", -1) do
      delete :destroy, id: substitute_phone
    end

    assert_redirected_to substitute_phones_path
  end

  private

  def substitute_phone
    @substitute_phone ||= create :substitute_phone
  end
end
