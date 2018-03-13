class PerformSliceWorker
  include Sidekiq::Worker

  def perform(*_args)
    redis = Redis.new(host: Rails.configuration.x.redis_host, port: Rails.configuration.x.redis_port, db: Rails.configuration.x.redis_db)

    status = redis.get('slice_status')

    client = TransmissionApi::Client.new(
      username: Rails.configuration.x.transmission_user,
      password: Rails.configuration.x.transmission_password,
      url: Rails.configuration.x.transmission_url
    )

    slice_dir = Rails.configuration.x.slice_dir

    if status == 'SLICING'
      puts 'Busy now, waiting for next slot.'
    else
      begin
        puts 'Idle now, starting job.'
        redis.set('slice_status', 'SLICING')
        path = client.config_get['download-dir']
        path += '/'
        p path

        item = Item.where(status: 'PENDING_SLICE').first
        if item
          p item.id
          task = client.find(item.taskid)
          if task['files'].length == 1
            path += task['name']
          else
            task['files'].each do |file|
              media_file_filter = /(\.mp4$)|(\.mkv$)|(\.ts$)/
              if media_file_filter.match(file['name'])
                path += file['name']
                break
              end
            end
          end
          item.status = 'SLICING'
          item.save

          vid = FFMPEG::Movie.new(path.to_s)
          if vid.video_codec == 'h264'
            `lib/slice_only.sh "#{path}" #{slice_dir}/#{item.id}`
          else
            `lib/slice_convert.sh "#{path}" #{slice_dir}/#{item.id} #{vid.resolution}`
          end
          item.status = 'AVAILABLE'
          item.save
        end
        redis.set('slice_status', 'IDLE')
        puts 'Job done.'
      rescue Exception => e
        puts e
        redis.set('slice_status', 'IDLE')
      end
    end
  end
end
