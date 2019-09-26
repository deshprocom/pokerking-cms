Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope ":locale", :path_prefix => '/:locale' do
    ActiveAdmin.routes(self)
  end

  root 'admin/users#index'
  resources :admin_images, only: [:create]
end
