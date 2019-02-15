ActiveAdmin.register HomepageBanner do
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'position_desc'

  permit_params :image, :source_id, :source_type, :position

  form partial: 'form'

  index do
    render 'index', context: self
  end
end