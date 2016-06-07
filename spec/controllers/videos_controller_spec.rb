require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do
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
      it_behaves_like "requires sign in" do
        let(:action) { get :show, id: video.id }
      end
    end
  end

  describe "POST search" do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
      end
      it "sets @video" do
        post :search, search_term: video.title
        expect(assigns(:results)).to eq([video])
      end
    end

    context "without unthenticated users" do
      it_behaves_like "requires sign in" do
        let(:action) { post :search, search_term: video.title }
      end
    end
  end
end
