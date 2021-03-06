require "redis"

redis = Redis.new(host: Rails.configuration.x.redis_host, port: Rails.configuration.x.redis_port, db: Rails.configuration.x.redis_db)

client = TransmissionApi::Client.new(
  :username => Rails.configuration.x.transmission_user,
  :password => Rails.configuration.x.transmission_password,
  :url      => Rails.configuration.x.transmission_url,
  :with_extra => true
)


path = client.config_get['download-dir']
path += '/'

client.all.each do | task |
  item = Item.find_by(:info_hash => task['hashString'])
  if (item) then
    item.taskid = task['id']
    # 作成ばかりのアイテム
    if (item.status == 'CREATED' ) then
      item.status = (task['percentDone'] == 1) ? 'PENDING_SLICE' : 'DOWNLOADING'
    # 削除保留中のアイテム
    elsif (item.status == 'PENDING_DELETE') then
      item.status = 'DELETED'
      client.destroy(task['id'], trashdata: true)
    # ダウンロード終了、HLSセグメント保存予定
    elsif (item.status == 'DOWNLOADING')
      if (task['percentDone'] == 1) then
        item.status = 'PENDING_SLICE'
      end
    end
    # ステータスを更新
    item.save
    # Redisにキャッシュ
    if (item.status != 'DELETED') then
      redis.set("item_#{item.id}_status", Marshal.dump(task))
    end
  end
end

# transmissionにタスクを追加
Item.where(:status => 'PENDING_CREATE').each do | item |
  client.create item.url
  item.status = 'CREATED'
  item.save
end
