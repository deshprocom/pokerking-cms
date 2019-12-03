set :output, "./log/cron_log.log"

every 1.minutes do
  rake 'batch_tasks:sync_last_sign_in'
end
