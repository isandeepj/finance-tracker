class UsersController < ApplicationController
  before_action :load_user, only: [:my_portfolio, :show]
  before_action :load_friends, only: [:my_friends, :search]

  def my_portfolio
    # @user = current_user
    # @tracked_stocks = current_user.stocks
  end

  def my_friends
    # @friends
  end

  def show
    # @user = User.find(params[:id])
    # @tracked_stocks = @user.stocks
  end

  def search
    @friends = []
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
  
      friends_found = @friends.present?
  
      respond_to do |format|
        flash.now[:alert] = "Couldn't find user" if !friends_found
  
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "friend-results",
            partial: "users/friend_result"
          )
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend name or email to search"
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "friend-results",
            partial: "users/friend_result"
          )
        end
      end
    end
  end
  


  private

  def load_user
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @tracked_stocks = @user.stocks
  end

  def load_friends
    @friends = current_user.friends
  end
end