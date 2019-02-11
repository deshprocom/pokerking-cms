ActiveAdmin.register EventSchedule do
  belongs_to :main_event
  config.sort_order = 'begin_time_asc'


  permit_params :name, :event_type, :event_num, :buy_in, :schedule_pdf, :starting_stack,
                :entries, :begin_time, :reg_open, :reg_close


  index do
    render 'index', context: self
  end
end
