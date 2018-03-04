require 'rss'

Feed.where(:is_finished => false).each do | feed |
  # Each feed
  rss = RSS::Parser.parse(feed.url, true)

  torrent_path = Rails.configuration.x.torrent_path
  torrent_url = Rails.configuration.x.torrent_url

  torrent_filter = /bangumi\.moe/
  is_torrent = false
  if torrent_filter.match(feed.url) then
    p "BGM!"
    is_torrent = true
  end

  #  Update last_updated
  feed.last_updated = rss.items.first.pubDate
  feed.save

  # Each torrent

  if feed.item != nil then
    rss.items.each_with_index do | item, index |
      ih = ""
      if is_torrent then
        if !File.exist?("#{torrent_path}/#{item.title}.torrent") then
          %x(curl --globoff -s "#{URI.encode(item.enclosure.url)}" --output "#{torrent_path}/#{item.title}.torrent")
        end
        item.enclosure.url = "#{torrent_url}/#{item.title}.torrent"
        File.open("#{torrent_path}/#{item.title}.torrent", "r") do | f |
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
    
      # Save Item.
      i = Item.find_by(:info_hash => ih)
      unless (i)
        i = Item.new
        i.name = item.title
        i.info_hash = ih
        i.url = item.enclosure.url
        i.feed_id = feed.id
        i.status = 'PENDING_CREATE'
        i.ep_id = rss.items.length - index + i.feed.offset.to_i
        i.save
    
      else # unless
        i.ep_id = rss.items.length - index + i.feed.offset.to_i
        i.save
      end
    end # rss.items.each
    feed.amount = feed.items.delete_if{| item | item.skip == true}.length
    feed.save
    end # Feed.all.each
  end
