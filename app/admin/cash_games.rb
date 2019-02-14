ActiveAdmin.register CashGame do
  permit_params :name, :image
  filter :name
  filter :created_at

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  form partial: 'form'

  sidebar '侧边栏', only: [:show] do
    cash_queue_sidebar_generator(self)
  end
end
