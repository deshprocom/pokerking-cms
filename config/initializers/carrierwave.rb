# 生产环境暂时没有cdn
CarrierWave.configure do |config|
  if ENV['ASSET_HOST'].present?
    config.storage = :file
    config.base_path = ENV['ASSET_HOST']
    config.remove_previously_stored_files_after_update = false
  else
    config.storage = :upyun
    config.upyun_username    = ENV['UPYUN_USERNAME']
    config.upyun_password    = ENV['UPYUN_PASSWD']
    config.upyun_bucket      = ENV['UPYUN_BUCKET']
    config.upyun_bucket_host = ENV['UPYUN_BUCKET_HOST']
  end
  # if Rails.env.test?
  #   config.storage = :file
  # else
  #   config.storage = :upyun
  #   config.upyun_username    = ENV['UPYUN_USERNAME']
  #   config.upyun_password    = ENV['UPYUN_PASSWD']
  #   config.upyun_bucket      = ENV['UPYUN_BUCKET']
  #   config.upyun_bucket_host = ENV['UPYUN_BUCKET_HOST']
  # end
end
