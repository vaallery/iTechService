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

describe RevaluationsController do

  # This should return the minimal set of attributes required to create a valid
  # Revaluation. As you add validations to Revaluation, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "revaluation_act" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RevaluationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all revaluations as @revaluations" do
      revaluation = Revaluation.create! valid_attributes
      get :index, {}, valid_session
      assigns(:revaluations).should eq([revaluation])
    end
  end

  describe "GET show" do
    it "assigns the requested revaluation as @revaluation" do
      revaluation = Revaluation.create! valid_attributes
      get :show, {:id => revaluation.to_param}, valid_session
      assigns(:revaluation).should eq(revaluation)
    end
  end

  describe "GET new" do
    it "assigns a new revaluation as @revaluation" do
      get :new, {}, valid_session
      assigns(:revaluation).should be_a_new(Revaluation)
    end
  end

  describe "GET edit" do
    it "assigns the requested revaluation as @revaluation" do
      revaluation = Revaluation.create! valid_attributes
      get :edit, {:id => revaluation.to_param}, valid_session
      assigns(:revaluation).should eq(revaluation)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Revaluation" do
        expect {
          post :create, {:revaluation => valid_attributes}, valid_session
        }.to change(Revaluation, :count).by(1)
      end

      it "assigns a newly created revaluation as @revaluation" do
        post :create, {:revaluation => valid_attributes}, valid_session
        assigns(:revaluation).should be_a(Revaluation)
        assigns(:revaluation).should be_persisted
      end

      it "redirects to the created revaluation" do
        post :create, {:revaluation => valid_attributes}, valid_session
        response.should redirect_to(Revaluation.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved revaluation as @revaluation" do
        # Trigger the behavior that occurs when invalid params are submitted
        Revaluation.any_instance.stub(:save).and_return(false)
        post :create, {:revaluation => { "revaluation_act" => "invalid value" }}, valid_session
        assigns(:revaluation).should be_a_new(Revaluation)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Revaluation.any_instance.stub(:save).and_return(false)
        post :create, {:revaluation => { "revaluation_act" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested revaluation" do
        revaluation = Revaluation.create! valid_attributes
        # Assuming there are no other revaluations in the database, this
        # specifies that the Revaluation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Revaluation.any_instance.should_receive(:update_attributes).with({ "revaluation_act" => "" })
        put :update, {:id => revaluation.to_param, :revaluation => { "revaluation_act" => "" }}, valid_session
      end

      it "assigns the requested revaluation as @revaluation" do
        revaluation = Revaluation.create! valid_attributes
        put :update, {:id => revaluation.to_param, :revaluation => valid_attributes}, valid_session
        assigns(:revaluation).should eq(revaluation)
      end

      it "redirects to the revaluation" do
        revaluation = Revaluation.create! valid_attributes
        put :update, {:id => revaluation.to_param, :revaluation => valid_attributes}, valid_session
        response.should redirect_to(revaluation)
      end
    end

    describe "with invalid params" do
      it "assigns the revaluation as @revaluation" do
        revaluation = Revaluation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Revaluation.any_instance.stub(:save).and_return(false)
        put :update, {:id => revaluation.to_param, :revaluation => { "revaluation_act" => "invalid value" }}, valid_session
        assigns(:revaluation).should eq(revaluation)
      end

      it "re-renders the 'edit' template" do
        revaluation = Revaluation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Revaluation.any_instance.stub(:save).and_return(false)
        put :update, {:id => revaluation.to_param, :revaluation => { "revaluation_act" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested revaluation" do
      revaluation = Revaluation.create! valid_attributes
      expect {
        delete :destroy, {:id => revaluation.to_param}, valid_session
      }.to change(Revaluation, :count).by(-1)
    end

    it "redirects to the revaluations list" do
      revaluation = Revaluation.create! valid_attributes
      delete :destroy, {:id => revaluation.to_param}, valid_session
      response.should redirect_to(revaluations_url)
    end
  end

end
