class BgmController < ApplicationController

  def index
    @bgms = Feed.all
  end

  def bangumi
    @feed = Feed.find(params[:id])
  end

  def play
    @item = Item.find(params[:id])
    @status = Marshal.load(StatCache::RedisCache::Redis.get("item_#{@item.id}_status"))
  end

  def cover
    feed = Feed.find(params[:id])
    send_data feed.cover, type: feed.cover_type
  end
end
