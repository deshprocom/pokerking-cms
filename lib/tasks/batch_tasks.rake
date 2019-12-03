namespace :batch_tasks do
  desc '每隔10分钟 同步一次用户的ip位置'
  task sync_last_sign_in: :environment do
    Rails.application.eager_load!
    puts 'sync_last_sign_in start'
    users = User.where('last_sign_in_ip != ?', '') # 需要翻译的用户
    users.each do |user|
      ip = user.last_sign_in_ip
      # 如果是127.0.0.1 那么显示本机
      if ip.eql? '127.0.0.1'
        location = '本机'
      else
        begin
          result = IpLocation.query(ip)
          location = "#{result['country_name']} | #{result['city']} | #{result['region_name']} | #{result['company']}"
        rescue
          location = ''
        end
      end
      user.update(last_sign_in_location: location)
    end
    puts 'sync_last_sign_in end'
  end
end