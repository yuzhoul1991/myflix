require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    let(:leader) { Fabricate(:user) }
    let(:follower) { Fabricate(:user) }
    let(:relationship) { Fabricate(:relationship, leader: leader, follower: follower) }
    before do
      session[:user_id] = follower.id
      get :index
    end
    it 'sets the @relationships variable' do
      expect(assigns(:relationships)).to eq([relationship])
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create, leader_id: 4 }
    end
    let(:leader) { Fabricate(:user) }
    let(:follower) { Fabricate(:user) }
    before do
      session[:user_id] = follower.id
    end
    it 'creates a relationship that current user follows the leader' do
      post :create, leader_id: leader.id
      expect(Relationship.all.count).to be(1)
    end
    it 'redirect to people path' do
      post :create, leader_id: leader.id
      expect(response).to redirect_to people_path
    end
    it 'does not create a relationship if the current user is already following the user' do
      Fabricate(:relationship, leader: leader, follower: follower)
      post :create, leader_id: leader.id
      expect(Relationship.all.count).to be(1)
    end
    it 'does not allow the user to follow self' do
      post :create, leader_id: follower.id
      expect(Relationship.all.count).to be(0)
    end
  end

  describe 'DELETE destroy' do
    let(:leader) { Fabricate(:user) }
    let(:follower) { Fabricate(:user) }
    let(:follower2) { Fabricate(:user) }
    let(:relationship) { Fabricate(:relationship, leader: leader, follower: follower) }
    it 'deletes the relationship if the user is a follower' do
      session[:user_id] = follower.id
      delete :destroy, id: relationship.id
      expect(Relationship.all.count).to be(0)
    end
    it 'does not delete the relationship if the user is not a follower' do
      session[:user_id] = follower2.id
      delete :destroy, id: relationship.id
      expect(Relationship.all.count).to be(1)
    end
    it 'redirect to people path' do
      session[:user_id] = follower.id
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3 }
    end
  end
end
