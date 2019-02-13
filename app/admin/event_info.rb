ActiveAdmin.register EventInfo do
  belongs_to :main_event
  config.sort_order = 'id_desc'


  permit_params :title, :image, :description, :main_event_id, :published, :created_at
  form partial: 'form'

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end
end
