require "redis"

redis = Redis.new(host: '127.0.0.1', port: 6379, db: 0)

client = TransmissionApi::Client.new(
  :username => 'imi415',
  :password => 'p@ssw0rd',
  :url      => 'http://127.0.0.1:9091/transmission/rpc'
)

client.all.each do | task |
  item = Item.find_by(:info_hash => task['hashString'])
  item.taskid = task['id']
  p task["files"].first
  if (item) then
    if (item.status == 'CREATED' ) then
      item.status = (task['percentDone'] == 1) ? 'PENDING_SLICE' : 'DOWNLOADING'
    elsif (item.status == 'PENDING_DELETE') then
      item.status = 'DELETED'
      client.destroy(task['id'], trashdata: true)
    elsif (item.status == 'DOWNLOADING')
      if (task['percentDone'] == 1) then
        item.status = 'PENDING_SLICE'
      end
    end
    item.save
    if (item.status != 'DELETED') then
      redis.set("item_#{item.id}_status", Marshal.dump(task))
    end
  end
end

Item.where(:status => 'PENDING_CREATE').each do | item |
  client.create item.url
  item.status = 'CREATED'
  item.save
end
