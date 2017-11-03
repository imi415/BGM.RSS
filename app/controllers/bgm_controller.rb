class BgmController < ApplicationController

  def index
    @bgms = Feed.all
  end

  def bangumi

  end

  def play
    @item = Item.find(params[:id])
  end
end
