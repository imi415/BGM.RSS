require 'rss'

Feed.all.each do | feed |
  # Each feed
  rss = RSS::Parser.parse(feed.url, true)

  torrent_filter = /bangumi\.moe/
  is_torrent = false
  if torrent_filter.match(feed.url) then
    p "BGM!"
    is_torrent = true
  end

  # Each torrent
  rss.items.each do | item |
    p item.title

    ih = ""

    if is_torrent then
      %x(curl --globoff -s "#{URI.encode(item.enclosure.url)}" --output "/tmp/#{item.title}.torrent")
      File.open("/tmp/#{item.title}.torrent", "r") do | f |
        str = f.read
        ih =  OpenSSL::Digest::SHA1.hexdigest(BEncode.load(str)["info"].bencode)
      end
    else
      magnet_ih_filter = /(magnet:\?xt=urn:btih:).*(\&dn)/
      ih = BaseX::RFC4648Base32.string_to_integer(magnet_ih_filter.match(item.enclosure.url)[0].slice(20, 32)).to_s(16)
    end

    while ih.length < 40
      ih.insert(0, '0')
    end
    p ih

    # Save Item.
    unless (Item.find_by(:info_hash => ih))
      i = Item.new
      i.name = item.title
      i.info_hash = ih
      i.url = item.enclosure.url
      i.feed_id = feed.id
      i.status = 'PENDING_CREATE'
      i.save
    end # unless
  end # rss.items.each
end # Feed.all.each
