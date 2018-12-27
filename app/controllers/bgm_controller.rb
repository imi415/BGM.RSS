class BgmController < ApplicationController

  def index
    @bgms = Feed.all
  end

  def timeline
    @bgms = Feed.where(:is_finished => false)
  end

  def bangumi
    @feed = Feed.find(params[:id])
  end

  def play
    @item = Item.find(params[:id])

    stat_str = StatCache::RedisCache::Redis.get("item_#{@item.id}_status")
    @status = {}
    @status["uploadedEver"] = 0
    @status["downloadedEver"] = 0

    if !stat_str.nil? then
      @status = Marshal.load(StatCache::RedisCache::Redis.get("item_#{@item.id}_status"))
    end

    @status = Marshal.load(StatCache::RedisCache::Redis.get("item_#{@item.id}_status"))
  end

  def cover
    feed = Feed.find(params[:id])
    send_data feed.cover, type: feed.cover_type
  end
end
