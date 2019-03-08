# 暂时不需要cdn
CarrierWave.configure do |config|
  config.storage = :file
  config.base_path = ENV['ASSET_HOST']
  config.remove_previously_stored_files_after_update = false
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