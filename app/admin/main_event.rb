ActiveAdmin.register MainEvent do

  permit_params :name, :logo, :begin_time, :end_time, :published, :description
  form partial: 'form'

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  sidebar '侧边栏', only: [:show] do
    main_event_sidebar_generator(self)
  end
end
