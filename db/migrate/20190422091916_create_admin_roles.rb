class CreateAdminRoles < ActiveRecord::Migration[5.2]
  def change
    # 用户权限表
    create_table :admin_roles do |t|
      t.string :name
      t.text   :permissions
      t.string :memo
    end

    create_table :admin_user_roles do |t|
      t.belongs_to :admin_user, index: true
      t.belongs_to :admin_role, index: true
    end
  end
end
