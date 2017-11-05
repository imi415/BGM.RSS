class BgmController < ApplicationController

  def index
    @bgms = Feed.all
  end

  def bangumi

  end

  def play
    @item = Item.find(params[:id])
  end

  def cover
    feed = Feed.find(params[:id])
    send_data feed.cover, type: feed.cover_type
  end
end
