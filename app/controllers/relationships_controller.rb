class RelationshipsController < ApplicationController
  before_filter :require_sign_in

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    Relationship.create(leader: leader, follower: current_user) unless current_user.following? leader
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
end
