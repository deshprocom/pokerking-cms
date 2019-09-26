ActiveAdmin::Devise::SessionsController.class_eval do
  def after_sign_in_path_for(resource)
    admin_users_path
  end

  def root_path
    "/"  #add your logic
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end