server '20.189.79.188', user: 'deploy', roles: %w{app db cache web}
set :ssh_options, {
  user: 'deploy', # overrides user setting above
  keys: %w(~/.ssh/id_rsa),
  port: 22555,
  forward_agent: false,
  auth_methods: %w(publickey password)
}

set :branch, ENV.fetch('REVISION', ENV.fetch('BRANCH', 'production'))
set :rails_env, 'production'
set :deploy_to, '/home/deploy/deploy/pokerking_cms'


# puma
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_env, fetch(:rails_env, 'production')
set :puma_threads, [0, 5]
set :puma_workers, 0