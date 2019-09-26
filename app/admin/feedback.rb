ActiveAdmin.register Feedback do
  config.batch_actions = false
  config.filters = false
  config.clear_action_items!
  config.sort_order = 'dealt_asc'
  actions :all, except: [:new, :edit]

  index do
    column :id
    column :nickname do |resource|
      resource.user&.nickname
    end
    column :content, sortable: false
    column :email, sortable: false
    column :dealt
    column :created_at
    actions defaults: false do |resource|
      if resource.dealt
        item '取消处理', deal_admin_feedback_path(resource), method: :post
      else
        item '确认处理', deal_admin_feedback_path(resource), method: :post
      end
    end
  end

  member_action :deal, method: :post do
    feedback = Feedback.find(params[:id])
    feedback.update(dealt: !feedback.dealt)
    redirect_back fallback_location: admin_feedbacks_url, notice: '操作成功'
  end
end
