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

    regexp = /(magnet:\?xt=urn:btih:).*(\&dn)/
    ih = BaseX::RFC4648Base32.string_to_integer(regexp.match(item.enclosure.url)[0].slice(20, 32)).to_s(16)

    while ih.length < 40
      ih.insert(0, '0')
    end
    p ih
    # Save Item.
    unless (Item.find_by(:info_hash => ih))
      # Not really create while debugging.
      client.create item.enclosure.url

      i = Item.new
      i.name = item.title
      i.info_hash = ih
      i.feed_id = feed.id
      i.status = 'CREATED'
      i.save
    end
  end # rss.items.each
end # Feed.all.each
