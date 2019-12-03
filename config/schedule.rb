set :output, "./log/cron_log.log"

every 10.minutes do
  rake 'batch_tasks:sync_last_sign_in'
end
