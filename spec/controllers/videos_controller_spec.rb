require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    context "with authenticated users" do
      let(:video) { Fabricate(:video) }
      let(:review1) { Fabricate(:review, video: video) }
      let(:review2) { Fabricate(:review, video: video) }
      before do
        session[:user_id] = Fabricate(:user).id
        get :show, id: video.id
      end
      it "sets @video" do
        expect(assigns(:video)).to eq(video)
      end
      it 'sets @reviews' do
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end
    context "without unthenticated users" do
      let(:video) { Fabricate(:video) }
      it 'redirect user to sign in page' do
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST search" do
    context "with authenticated users" do
      let(:video) { Fabricate(:video) }
      before do
        session[:user_id] = Fabricate(:user).id
      end
      it "sets @video" do
        post :search, search_term: video.title
        expect(assigns(:results)).to eq([video])
      end
    end

    context "without unthenticated users" do
      let(:video) { Fabricate(:video) }
      it 'redirect user to sign in page' do
        post :search, search_term: video.title
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
