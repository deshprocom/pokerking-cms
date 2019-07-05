ActiveAdmin.register InfoTag do
  menu priority: 5, parent: 'info'
  config.filters = false

  permit_params :name, :name_en

  index do
    id_column
    column :name, sortable: false
    column(:name_en, sortable: false)
    actions
  end
end