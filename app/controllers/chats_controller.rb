class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    # TODO: Fetch user's chats
  end
end
