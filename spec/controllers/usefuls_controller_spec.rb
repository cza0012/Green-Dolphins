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

describe UsefulsController do

  # This should return the minimal set of attributes required to create a valid
  # Useful. As you add validations to Useful, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsefulsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all usefuls as @usefuls" do
      useful = Useful.create! valid_attributes
      get :index, {}, valid_session
      assigns(:usefuls).should eq([useful])
    end
  end

  describe "GET show" do
    it "assigns the requested useful as @useful" do
      useful = Useful.create! valid_attributes
      get :show, {:id => useful.to_param}, valid_session
      assigns(:useful).should eq(useful)
    end
  end

  describe "GET new" do
    it "assigns a new useful as @useful" do
      get :new, {}, valid_session
      assigns(:useful).should be_a_new(Useful)
    end
  end

  describe "GET edit" do
    it "assigns the requested useful as @useful" do
      useful = Useful.create! valid_attributes
      get :edit, {:id => useful.to_param}, valid_session
      assigns(:useful).should eq(useful)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Useful" do
        expect {
          post :create, {:useful => valid_attributes}, valid_session
        }.to change(Useful, :count).by(1)
      end

      it "assigns a newly created useful as @useful" do
        post :create, {:useful => valid_attributes}, valid_session
        assigns(:useful).should be_a(Useful)
        assigns(:useful).should be_persisted
      end

      it "redirects to the created useful" do
        post :create, {:useful => valid_attributes}, valid_session
        response.should redirect_to(Useful.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved useful as @useful" do
        # Trigger the behavior that occurs when invalid params are submitted
        Useful.any_instance.stub(:save).and_return(false)
        post :create, {:useful => {}}, valid_session
        assigns(:useful).should be_a_new(Useful)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Useful.any_instance.stub(:save).and_return(false)
        post :create, {:useful => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested useful" do
        useful = Useful.create! valid_attributes
        # Assuming there are no other usefuls in the database, this
        # specifies that the Useful created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Useful.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => useful.to_param, :useful => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested useful as @useful" do
        useful = Useful.create! valid_attributes
        put :update, {:id => useful.to_param, :useful => valid_attributes}, valid_session
        assigns(:useful).should eq(useful)
      end

      it "redirects to the useful" do
        useful = Useful.create! valid_attributes
        put :update, {:id => useful.to_param, :useful => valid_attributes}, valid_session
        response.should redirect_to(useful)
      end
    end

    describe "with invalid params" do
      it "assigns the useful as @useful" do
        useful = Useful.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Useful.any_instance.stub(:save).and_return(false)
        put :update, {:id => useful.to_param, :useful => {}}, valid_session
        assigns(:useful).should eq(useful)
      end

      it "re-renders the 'edit' template" do
        useful = Useful.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Useful.any_instance.stub(:save).and_return(false)
        put :update, {:id => useful.to_param, :useful => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested useful" do
      useful = Useful.create! valid_attributes
      expect {
        delete :destroy, {:id => useful.to_param}, valid_session
      }.to change(Useful, :count).by(-1)
    end

    it "redirects to the usefuls list" do
      useful = Useful.create! valid_attributes
      delete :destroy, {:id => useful.to_param}, valid_session
      response.should redirect_to(usefuls_url)
    end
  end

end