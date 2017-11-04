redis = Redis.new(host: '127.0.0.1', port: 6379, db: 0)

status = redis.get("slice_status")

client = TransmissionApi::Client.new(
  :username => 'imi415',
  :password => 'p@ssw0rd',
  :url      => 'http://127.0.0.1:9091/transmission/rpc'
)

slice_dir = '/var/www/html/hls'

unless (status == 'SLICING')
  puts "Idle now, starting job."
  redis.set("slice_status", 'SLICING')
  path = client.config_get['download-dir']
  path += '/'
  p path

  item = Item.where(:status => 'PENDING_SLICE').first
  if (item)
    p item.id
    task = client.find(item.taskid)
    path += task['name']
    unless task['files'].length == 1 then
      task['files'].each do | file |
        media_file_filter = /(\.mp4$)|(\.mkv$)|(\.ts$)/
        if media_file_filter.match(file['name'])
          path += file['name']
          break
        end
      end
    end
    item.status = 'SLICING'
    item.save

    vid = FFMPEG::Movie.new("#{path}")
    if vid.video_codec == 'h264' then
      %x(#{File.dirname(__FILE__)}/slice_only.sh "#{path}" #{slice_dir}/#{item.id})
    else
      %x(#{File.dirname(__FILE__)}/slice_convert.sh "#{path}" #{slice_dir}/#{item.id} #{vid.rsolution})
    end
    item.status = 'AVAILABLE'
    item.save
  end
  redis.set("slice_status", 'IDLE')
  puts "Job done."
else
  puts "Busy now, waiting for next slot."
end
