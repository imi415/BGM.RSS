redis = Redis.new(host: '127.0.0.1', port: 6379, db: 0)

status = redis.get("slice_status")

client = TransmissionApi::Client.new(
  :username => 'imi415',
  :password => 'p@ssw0rd',
  :url      => 'http://127.0.0.1:9091/transmission/rpc'
)

unless (status == 'SLICING')
  puts "Idle now, starting job."
  redis.set("slice_status", 'SLICING')

  item = Item.where(:status => 'PENDING_SLICE').first

  redis.set("slice_status", 'IDLE')
  puts "Job done."
else
  puts "Busy now, waiting for next slot."
end
