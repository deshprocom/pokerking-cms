ActiveAdmin.register CashGame do
  permit_params :name, :image, :image_en, :image_complex, :notice, :table_type, :amap_poiid, :amap_location
  filter :name
  filter :created_at
  config.sort_order = 'position_desc'

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  form partial: 'form'

  sidebar 'Sidebar', only: [:show] do
    cash_queue_sidebar_generator(self)
  end

  member_action :reposition, method: :post do
    cash_game = CashGame.find(params[:id])
    next_cash_game = params[:next_id] && CashGame.find(params[:next_id].split('_').last)
    prev_cash_game = params[:prev_id] && CashGame.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_cash_game.position + 100000
               elsif params[:next_id].blank?
                 prev_cash_game.position / 2
               else
                 (prev_cash_game.position + next_cash_game.position) / 2
               end
    cash_game.update(position: position)
  end

  collection_action :amap_detail, method: :get do
    response = Faraday.get('https://restapi.amap.com/v3/place/detail',
                           key: ENV['AMAP_KEY'],
                           id: params[:poiid])
    pois = JSON.parse(response.body)['pois']
    @poi = pois.presence ? pois[0] : {}
  end
end
