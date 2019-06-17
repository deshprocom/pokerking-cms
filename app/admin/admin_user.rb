ActiveAdmin.register AdminUser do
  menu priority: 1, parent: 'admin'
  permit_params :email, :password, :password_confirmation, admin_role_ids: []

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :admin_roles do |user|
      user.admin_roles.map(&:name).join(' ')
    end
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin_roles, as: :check_boxes
    end
    f.actions
  end

  controller do
    before_action :process_params, only: [:create, :update]

    def process_params
      return unless params[:admin_user][:password].blank?

      params[:admin_user].delete(:password)
      params[:admin_user].delete(:password_confirmation)
    end
  end
end
