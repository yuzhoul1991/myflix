require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: user) }
      let(:queue_item2) { Fabricate(:queue_item, user: user) }
      before do
        set_current_user user
        get :index
      end
      it 'sets @queue_items for the current logged in user' do
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end
    end
    context "with unauthenticated user" do
      it_behaves_like "requires sign in" do
        let(:action) { get :index }
      end
    end
  end

  describe "POST create" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:existing_video) { Fabricate(:video) }
      before do
        set_current_user user
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
      it_behaves_like "requires sign in" do
        let(:action) { post :create, video_id: video.id }
      end
    end
  end

  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item) { Fabricate(:queue_item, user: user, position: 1, video: video) }
      before do
        set_current_user user
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
      it 'normalize the remaining queue_items' do
        queue_item2 = Fabricate(:queue_item, user: user, position: 2, video: video)
        delete :destroy, id: queue_item.id
        expect(queue_item2.reload.position).to eq(1)
      end
    end
    context "with unauthenticated user" do
      it_behaves_like "requires sign in" do
        let(:action) { delete :destroy, id: 1 }
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: user, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: user, video: video) }
      before do
        set_current_user user
      end
      it 'redirects to the my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it 're-order the queue items' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(user.queue_items).to eq([queue_item2, queue_item1])
      end
      it 'normailze the position numbers' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 4}, {id: queue_item2.id, position: 2}]
        expect(user.queue_items.map(&:position)).to eq([1, 2])
      end
    end
    context "with invalid inputs" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: user, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: user, video: video) }
      before(:each) do
        set_current_user user
      end
      it 'redirects to my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: -1}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end
      it 'sets flash error message' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: -1}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end
      it 'does not change the queue items' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: -2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    context "with unauthenticated users" do
      it_behaves_like "requires sign in" do
        let(:action) { post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 2}] }
      end
    end
    context "with queue items that do not belong to current user" do
      let(:user1) { Fabricate(:user) }
      let(:user2) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: user2)}
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: user2)}
      before do
        session[:user_id] = user1.id
      end
      it 'redirect to my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 6}, {id: queue_item2.id, position: 3}]
        expect(response).to redirect_to my_queue_path
      end
      it 'does not change the queue_items' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 6}, {id: queue_item2.id, position: 3}]
        expect(user2.queue_items.map(&:position)).to eq([1, 2])
      end
    end
  end
end
