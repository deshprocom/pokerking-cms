ActiveAdmin.register MainEvent do

  permit_params :name, :logo, :begin_time, :end_time, :published
  form partial: 'form'

  index do
    render 'index', context: self
  end
end
