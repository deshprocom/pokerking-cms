ActiveAdmin.register Info do
  belongs_to :main_event, optional: true
  config.sort_order = 'id_desc'

  permit_params :title, :image, :description, :source, :published,
                :created_at, :main_event_id, :only_show_in_event
  form partial: 'form'

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end
end
