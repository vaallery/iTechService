require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe InstallmentsController do

  # This should return the minimal set of attributes required to create a valid
  # Installment. As you add validations to Installment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "installment_plan" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # InstallmentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all installments as @installments" do
      installment = Installment.create! valid_attributes
      get :index, {}, valid_session
      assigns(:installments).should eq([installment])
    end
  end

  describe "GET show" do
    it "assigns the requested installment as @installment" do
      installment = Installment.create! valid_attributes
      get :show, {:id => installment.to_param}, valid_session
      assigns(:installment).should eq(installment)
    end
  end

  describe "GET new" do
    it "assigns a new installment as @installment" do
      get :new, {}, valid_session
      assigns(:installment).should be_a_new(Installment)
    end
  end

  describe "GET edit" do
    it "assigns the requested installment as @installment" do
      installment = Installment.create! valid_attributes
      get :edit, {:id => installment.to_param}, valid_session
      assigns(:installment).should eq(installment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Installment" do
        expect {
          post :create, {:installment => valid_attributes}, valid_session
        }.to change(Installment, :count).by(1)
      end

      it "assigns a newly created installment as @installment" do
        post :create, {:installment => valid_attributes}, valid_session
        assigns(:installment).should be_a(Installment)
        assigns(:installment).should be_persisted
      end

      it "redirects to the created installment" do
        post :create, {:installment => valid_attributes}, valid_session
        response.should redirect_to(Installment.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved installment as @installment" do
        # Trigger the behavior that occurs when invalid params are submitted
        Installment.any_instance.stub(:save).and_return(false)
        post :create, {:installment => { "installment_plan" => "invalid value" }}, valid_session
        assigns(:installment).should be_a_new(Installment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Installment.any_instance.stub(:save).and_return(false)
        post :create, {:installment => { "installment_plan" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested installment" do
        installment = Installment.create! valid_attributes
        # Assuming there are no other installments in the database, this
        # specifies that the Installment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Installment.any_instance.should_receive(:update_attributes).with({ "installment_plan" => "" })
        put :update, {:id => installment.to_param, :installment => { "installment_plan" => "" }}, valid_session
      end

      it "assigns the requested installment as @installment" do
        installment = Installment.create! valid_attributes
        put :update, {:id => installment.to_param, :installment => valid_attributes}, valid_session
        assigns(:installment).should eq(installment)
      end

      it "redirects to the installment" do
        installment = Installment.create! valid_attributes
        put :update, {:id => installment.to_param, :installment => valid_attributes}, valid_session
        response.should redirect_to(installment)
      end
    end

    describe "with invalid params" do
      it "assigns the installment as @installment" do
        installment = Installment.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Installment.any_instance.stub(:save).and_return(false)
        put :update, {:id => installment.to_param, :installment => { "installment_plan" => "invalid value" }}, valid_session
        assigns(:installment).should eq(installment)
      end

      it "re-renders the 'edit' template" do
        installment = Installment.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Installment.any_instance.stub(:save).and_return(false)
        put :update, {:id => installment.to_param, :installment => { "installment_plan" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested installment" do
      installment = Installment.create! valid_attributes
      expect {
        delete :destroy, {:id => installment.to_param}, valid_session
      }.to change(Installment, :count).by(-1)
    end

    it "redirects to the installments list" do
      installment = Installment.create! valid_attributes
      delete :destroy, {:id => installment.to_param}, valid_session
      response.should redirect_to(installments_url)
    end
  end

end
