ActiveAdmin.register Info do
  menu priority: 4, parent: '资料'
  config.sort_order = 'position_desc'
  belongs_to :main_event, optional: true

  permit_params :title, :image, :description, :source, :published,
                :created_at, :main_event_id, :only_show_in_event, :hot

  scope :all
  scope :hot, &:hot

  filter :title
  filter :source
  filter :description
  filter :published
  filter :created_at
  filter :only_show_in_event
  filter :hot

  form partial: 'form'

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  # 上热门
  member_action :hot, method: :post do
    resource.hot!
    redirect_back fallback_location: admin_infos_url, notice: '上热门成功'
  end

  # 取消上热门
  member_action :unhot, method: :post do
    resource.unhot!
    redirect_back fallback_location: admin_infos_url, notice: '取消热门成功'
  end

  member_action :reposition, method: :post do
    item = Info.find(params[:id])
    next_item = params[:next_id] && Info.find(params[:next_id].split('_').last)
    prev_item = params[:prev_id] && Info.find(params[:prev_id].split('_').last)
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
