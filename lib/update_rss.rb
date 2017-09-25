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
    p item.title
    client.create item.enclosure.url
    regexp = /(magnet:\?xt=urn:btih:).*(\&dn)/
    p Base32.decode(regexp.match(item.enclosure.url)[0].slice(20, 32)).each_byte.map { |b| b.to_s(16) }.join
    
  end # rss.items.each
end # Feed.all.each
