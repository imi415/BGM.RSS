client = TransmissionApi::Client.new(
  :username => 'imi415',
  :password => 'p@ssw0rd',
  :url      => 'http://127.0.0.1:9091/transmission/rpc'
)

client.all.each do | task |
  item = Item.find_by(:info_hash => task['hashString']);
  if (item && item.status != 'FINISHED' ) then
    item.status = task['isFinished'] ? 'FINISHED' : 'DOWNLOADING'
    item.save
  end
end
