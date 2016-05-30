require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before do
        session[:user_id] = current_user.id
      end
      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end
        it 'creates a review' do
          expect(Review.count).to eq(1)
        end
        it 'creates a review associated with video' do
          expect(Review.first.video).to eq(video)
        end
        it 'creates a review assicated with the signed in user' do
          expect(Review.first.user).to eq(current_user)
        end
        it 'redirect to video show page' do
          expect(response).to redirect_to video_path(video)
        end
        it 'sets notice' do
          expect(flash[:notice]).not_to be_blank
        end
      end
      context "with invalid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review, body: nil), video_id: video.id
        end
        it 'does not create a review' do
          expect(Review.count).to be(0)
        end
        it 'render the videos/show template' do
          expect(response).to render_template('videos/show')
        end
        it 'sets @video' do
          expect(assigns(:video)).to eq(video)
        end
        it 'sets @reviews' do
          expect(assigns(:reviews)).to eq(video.reviews)
        end
      end
    end

    context "with unauthenticated users" do
      before do
        post :create, review: Fabricate.attributes_for(:review, body: nil), video_id: video.id
      end
      it 'redirects to sign in path' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
