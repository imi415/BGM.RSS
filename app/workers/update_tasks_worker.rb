require 'redis'
class UpdateTasksWorker
  include Sidekiq::Worker

  def perform(*_args)
    redis = Redis.new(host: Rails.configuration.x.redis_host, port: Rails.configuration.x.redis_port, db: Rails.configuration.x.redis_db)
    client = TransmissionApi::Client.new(
      username: Rails.configuration.x.transmission_user,
      password: Rails.configuration.x.transmission_password,
      url: Rails.configuration.x.transmission_url,
      with_extra: true
    )
    path = client.config_get['download-dir']
    path += '/'
    client.find_each {| task |
      item = Item.find_by(info_hash: task['hashString'])
      next unless item
      item.taskid = task['id']
      # 作成ばかりのアイテム
      if item.status == 'CREATED'
        item.status = task['percentDone'] == 1 ? 'PENDING_SLICE' : 'DOWNLOADING'
      # 削除保留中のアイテム
      elsif item.status == 'PENDING_DELETE'
        item.status = 'DELETED'
        client.destroy(task['id'], trashdata: true)
      # ダウンロード終了、HLSセグメント保存予定
      elsif item.status == 'DOWNLOADING'
        item.status = 'PENDING_SLICE' if task['percentDone'] == 1
      end
      # ステータスを更新
      item.save
      # Redisにキャッシュ
      if item.status != 'DELETED'
        redis.set("item_#{item.id}_status", Marshal.dump(task))
      end
    }
    # transmissionにタスクを追加
    Item.where(status: 'PENDING_CREATE').find_each {| item |
      client.create item.url
      item.status = 'CREATED'
      item.save
    }
  end
end
