ActiveAdmin.register HomepageBanner do
  menu priority: 5, parent: 'info'
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'position_desc'

  permit_params :image, :source_id, :source_type, :position

  form partial: 'form'

  index do
    render 'index', context: self
  end

  member_action :reposition, method: :post do
    item = HomepageBanner.find(params[:id])
    next_item = params[:next_id] && HomepageBanner.find(params[:next_id].split('_').last)
    prev_item = params[:prev_id] && HomepageBanner.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_item.position + 100000
               elsif params[:next_id].blank?
                 prev_item.position / 2
               else
                 (prev_item.position + next_item.position) / 2
               end
    item.update(position: position)
  end
end