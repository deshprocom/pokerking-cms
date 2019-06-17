ActiveAdmin.register AdminRole do
  menu priority: 2, parent: 'admin'
  config.filters = false
  permit_params :name, :memo, permissions: []

  form do |f|
    f.inputs do
      f.input :name
      f.input :memo
      f.input :permissions,
              as: :check_boxes,
              collection: CmsAuthorization.permissions_with_trans
    end
    f.actions
  end

  index do
    id_column
    column :name, sortable: false
    column(:permissions, sortable: false, &:permissions_text)
    column(:memo, sortable: false)
    actions
  end

  show do
    attributes_table do
      row(:id)
      row(:name)
      row(:permissions, &:permissions_text)
      row(:memo)
    end
  end

  controller do
    before_action :process_params, only: [:create, :update]
    before_action :destroy_super_admin?, only: [:destroy]

    def process_params
      params[:admin_role][:permissions].reject!(&:empty?)
    end

    def destroy_super_admin?
      return unless resource.name == 'Super Admin'

      flash[:error] = 'Cannot delete Super Admin'
      redirect_back fallback_location: admin_admin_roles_url
    end
  end
end
