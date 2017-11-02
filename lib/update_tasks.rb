require "redis"

redis = Redis.new(host: '127.0.0.1', port: 6379, db: 0)

client = TransmissionApi::Client.new(
  :username => 'imi415',
  :password => 'p@ssw0rd',
  :url      => 'http://127.0.0.1:9091/transmission/rpc'
)

client.all.each do | task |
  item = Item.find_by(:info_hash => task['hashString']);
  if (item) then
    if (item.status == 'CREATED' ) then
      item.status = (task['percentDone'] == 1) ? 'PENDING_SLICE' : 'DOWNLOADING'
      item.save
    elsif (item.status == 'PENDING_DELETE') then
      item.status = 'DELETED'
      item.save
      client.destroy(task['id'], trashdata: true)
    elsif (item.status == 'DOWNLOADING' || item.status == 'PENDING_SLICE' || item.status == 'FINISHED') then
      redis.set("item_#{item.id}_status", Marshal.dump(task))
    end
  end
end

Item.where(:status => 'PENDING_CREATE').each do | item |
  client.create item.url
  item.status = 'CREATED'
  item.save
end
