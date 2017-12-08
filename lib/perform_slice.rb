redis = Redis.new(host: config.x.redis_host, port: config.x.redis_port, db: config.x.redis_db)

status = redis.get("slice_status")

client = TransmissionApi::Client.new(
  :username => config.x.transmission_user,
  :password => config.x.transmission_password,
  :url      => config.x.transmission_url
)

slice_dir = config.x.slice_dir

unless (status == 'SLICING')
  begin
    puts "Idle now, starting job."
    redis.set("slice_status", 'SLICING')
    path = client.config_get['download-dir']
    path += '/'
    p path

    item = Item.where(:status => 'PENDING_SLICE').first
    if (item)
      p item.id
      task = client.find(item.taskid)
      unless task['files'].length == 1 then
        task['files'].each do | file |
          media_file_filter = /(\.mp4$)|(\.mkv$)|(\.ts$)/
          if media_file_filter.match(file['name'])
            path += file['name']
            break
          end
        end
      else
        path += task['name']
      end
      item.status = 'SLICING'
      item.save

      vid = FFMPEG::Movie.new("#{path}")
      if vid.video_codec == 'h264' then
        %x(#{File.dirname(__FILE__)}/slice_only.sh "#{path}" #{slice_dir}/#{item.id})
      else
        %x(#{File.dirname(__FILE__)}/slice_convert.sh "#{path}" #{slice_dir}/#{item.id} #{vid.resolution})
      end
      item.status = 'AVAILABLE'
      item.save
    end
    redis.set("slice_status", 'IDLE')
    puts "Job done."
  rescue Exception  => e
    puts e
    redis.set("slice_status", 'IDLE')
  end
else
  puts "Busy now, waiting for next slot."
end
