require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: user) }
      let(:queue_item2) { Fabricate(:queue_item, user: user) }
      before do
        session[:user_id] = user.id
        get :index
      end
      it 'sets @queue_items for the current logged in user' do
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end
    end
    context "with unauthenticated user" do
      before do
        get :index
      end
      it 'redirect to sign in page' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST create" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:existing_video) { Fabricate(:video) }
      before do
        session[:user_id] = user.id
      end
      it 'redirects to my queue page' do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
      it 'creates a queue item' do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it 'creates a queue item that is associated with the user' do
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(user)
      end
      it 'creates a queue item that is associated with the video' do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it 'puts the video as the last video in the queue' do
        Fabricate(:queue_item, video: existing_video, user: user)
        post :create, video_id: video.id
        new_queue_item = QueueItem.where(video_id: video.id, user_id: user.id).first
        expect(new_queue_item.position).to eq(2)
      end
      it 'does not add the video if the video is already in the queue' do
        Fabricate(:queue_item, user: user, video: video)
        post :create, video_id: video.id
        expect(user.queue_items.count).to eq(1)
      end
      it 'sets notice when user attempt to add existing_video to the queue' do
        Fabricate(:queue_item, user: user, video: video)
        post :create, video_id: video.id
        expect(flash[:notice]).not_to be_nil
      end
      it 'stays on the same video page if the user attempts to add existing_video to the queue' do
        Fabricate(:queue_item, user: user, video: video)
        post :create, video_id: video.id
        expect(response).to redirect_to video_path(video)
      end
    end
    context "with unauthenticated users" do
      let(:video) { Fabricate(:video) }
      before do
        post :create, video_id: video.id
      end
      it 'redirect to sign in page for unauthenticated users' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }
      before do
        session[:user_id] = user.id
      end
      it 'removes the queue item' do
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to be(0)
      end
      it 'stays on the same page' do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end
      it 'sets a notice' do
        delete :destroy, id: queue_item.id
        expect(flash[:notice]).not_to be_nil
      end
      it 'does not delete the queue item if the queue item is not in the users queue' do
        another_user = Fabricate(:user)
        another_queue_item = Fabricate(:queue_item, user: another_user, video: video)
        delete :destroy, id: another_queue_item.id
        expect(QueueItem.count).to be(1)
      end
    end
  end
  context "with unauthenticated user" do
    before do
      delete :destroy, id: 1
    end
    it 'redirect to sign in page' do
      expect(response).to redirect_to sign_in_path
    end
  end
end
