ActiveAdmin.register Info do
  menu priority: 4, parent: 'info'
  config.sort_order = 'position_desc'
  belongs_to :main_event, optional: true

  permit_params :title, :image, :description, :source, :published,
                :created_at, :main_event_id, :only_show_in_event, :hot, :location,
                info_en_attributes: [:id, :title, :source, :description], info_tc_attributes: [:id, :title, :source, :description]

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

  controller do
    def create
      @info = Info.create!(create_params)
      # 如果创建成功 那么查看是否上传了 tag ids
      recreate_tag_relation
      redirect_to admin_infos_url
    end

    def update
      resource.update(create_params)
      # 取出之前的所有标签
      old_relations = @info.reload.info_tag_relations
      old_relations.each(&:destroy)
      recreate_tag_relation
      redirect_to admin_infos_url
    end

    private

    def recreate_tag_relation
      if params[:tag_ids].present? && params[:tag_ids].length > 0
        params[:tag_ids].each do |item|
          InfoTagRelation.create!(info_id: @info.id, info_tag_id: item)
        end
      end
    end

    def create_params
      params.require(:info).permit(:title,
                                   :image,
                                   :description,
                                   :source,
                                   :published,
                                   :created_at,
                                   :main_event_id,
                                   :only_show_in_event,
                                   :hot,
                                   :location,
                                   info_en_attributes: [:id, :title, :source, :description],
                                   info_tc_attributes: [:id, :title, :source, :description])
    end
  end

  # 上热门
  member_action :hot, method: :post do
    resource.hot!
    redirect_back fallback_location: admin_infos_url, notice: 'Update Success'
  end

  # 取消上热门
  member_action :unhot, method: :post do
    resource.unhot!
    redirect_back fallback_location: admin_infos_url, notice: 'Cancel Success'
  end

  # 下发消息
  member_action :notify, method: :post do
    Notification.create_info_notify(resource)
    redirect_back fallback_location: admin_infos_url, notice: 'send Success'
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
