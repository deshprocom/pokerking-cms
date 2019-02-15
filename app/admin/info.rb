ActiveAdmin.register Info do
  config.sort_order = 'id_desc'

  permit_params :title, :image, :description, :source, :published, :created_at
  form partial: 'form'

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end
end
