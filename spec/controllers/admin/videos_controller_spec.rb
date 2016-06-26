require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end
    it_behaves_like 'requires admin' do
      let(:action) { get :new }
    end
    context 'with admin user' do
      let(:admin) { Fabricate(:admin) }
      before do
        set_current_user admin
        get :new
      end
      it 'sets the @video variable' do
        expect(assigns(:video)).to be_instance_of(Video)
        expect(assigns(:video)).to be_new_record
      end
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
    it_behaves_like 'requires admin' do
      let(:action) { post :create }
    end
    context 'with valid inputs' do
      let(:category) { Fabricate(:category) }
      let(:admin) { Fabricate(:admin) }
      before do
        set_current_user admin
        post :create, video: Fabricate.attributes_for(:video).merge(category_id: category.id)
      end
      it 'creates a new video under the category' do
        expect(category.videos.count).to eq(1)
      end
      it 'redirect back to the add vidoe page' do
        expect(response).to redirect_to new_admin_video_path
      end
      it 'sets a success flash message' do
        expect(flash[:notice]).to be_present
      end
    end
    context 'with invalid inputs' do
      let(:category) { Fabricate(:category) }
      let(:admin) { Fabricate(:admin) }
      before do
        set_current_user admin
        post :create, video: Fabricate.attributes_for(:video, title: nil)
      end
      it 'does not create a new video' do
        expect(Video.count).to be(0)
      end
      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
      it 'sets the @video variable' do
        expect(assigns(:video)).to be_instance_of Video
      end
      it 'sets the flash error message' do
        expect(flash[:error]).to be_present
      end
    end
  end
end
