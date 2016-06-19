require 'spec_helper'

describe UsersController do
  describe  "GET new" do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end
    context 'with authenticated user' do
      let(:user) { Fabricate(:user) }
      before do
        set_current_user
        get :show, id: user.id
      end
      it 'sets the variable @user' do
        expect(assigns(:user)).to eq(user)
      end
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "creates the user" do
        expect(User.count).to eq(1)
      end
      it 'redirect to sign in path' do
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with invalid input" do
      before do
        post :create, user: { password: 'password', fullname: Faker::Name.name }
      end
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it 'render the :new template' do
        expect(response).to render_template :new
      end
      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
    context 'sending emails' do
      let(:user) { Fabricate.attributes_for(:user) }
      after do
        ActionMailer::Base.deliveries.clear
      end
      it 'sends out email to user with valid inputs' do
        post :create, user: user
        expect(ActionMailer::Base.deliveries.last.to).to eq([user[:email]])
      end
      it 'sends out email with the user fullname' do
        post :create, user: user
        expect(ActionMailer::Base.deliveries.last.body).to include(user[:fullname])
      end
      it 'does not send email with invalid inputs' do
        post :create, user: user.merge!(fullname: nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
