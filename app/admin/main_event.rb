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

  controller do
    def scoped_collection
      super.position_desc.begin_asc
    end
  end

  member_action :reposition, method: :post do
    cash_game = MainEvent.find(params[:id])
    next_cash_game = params[:next_id] && MainEvent.find(params[:next_id].split('_').last)
    prev_cash_game = params[:prev_id] && MainEvent.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_cash_game.position + 100000
               elsif params[:next_id].blank?
                 prev_cash_game.position / 2
               else
                 (prev_cash_game.position + next_cash_game.position) / 2
               end
    cash_game.update(position: position)
  end
end
