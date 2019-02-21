ActiveAdmin.register PlatformQuestion do
  permit_params :description
  config.batch_actions = false
  config.filters = false

  form partial: 'form'

  index do
    render 'index', context: self
  end
end
