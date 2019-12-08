ActiveAdmin.register User do
  menu priority: 1

  actions :all, except: [:destroy, :edit, :new]

  filter :user_uuid
  filter :nickname
  filter :mobile
  filter :email
  filter :reg_date

  index do
    render 'index', context: self
  end

  # 上热门
  member_action :preview, method: :post do
    resource.update(preview: true)
    redirect_back fallback_location: admin_users_url, notice: 'Update Success'
  end

  # 取消上热门
  member_action :unpreview, method: :post do
    resource.update(preview: false)
    redirect_back fallback_location: admin_users_url, notice: 'Cancel Success'
  end
end
