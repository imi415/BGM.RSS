require 'rss'
client = TransmissionApi::Client.new(
  :username => 'imi415',
  :password => 'p@ssw0rd',
  :url      => 'http://127.0.0.1:9091/transmission/rpc'
)

# p client.all

# p Feed.all

Feed.all.each do | feed |
  # Each feed
  rss = RSS::Parser.parse(feed.url, true)
  
  # Each torrent
  rss.items.each do | item |
    # p item.title
    client.create item.enclosure.url

  end # rss.items.each
end # Feed.all.each
