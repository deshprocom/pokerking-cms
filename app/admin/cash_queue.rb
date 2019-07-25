ActiveAdmin.register CashQueue do
  belongs_to :cash_game
  config.sort_order = 'position_desc'
  permit_params :small_blind, :big_blind, :members, :buy_in, :table_no, :table_people, :currency, :high_limit, :transfer, :notice, :navigation, :straddle, :position, :queue_type

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  form partial: 'form'

  controller do
    before_action :set_cash_game
    before_action :set_cash_queue, only: [:edit, :update, :destroy]

    def new
      @cash_queue = @cash_game.cash_queues.build
    end

    def create
      @cash_game.cash_queues.create(user_params)
      # render :index
      redirect_to admin_cash_game_cash_queues_path(@cash_game)
    end

    def update
      @cash_queue.update_attributes(user_params)
      redirect_to admin_cash_game_cash_queues_path(@cash_queue.cash_game)
    end

    def set_cash_game
      @cash_game = CashGame.find(params[:cash_game_id])
    end

    def set_cash_queue
      @cash_queue = @cash_game.cash_queues.find(params[:id])
    end

    private

    def user_params
      params.require(:cash_queue)
            .permit(:small_blind, :big_blind, :members, :buy_in, :table_no, :table_people, :high_limit, :currency, :transfer, :notice, :navigation, :straddle, :position, :queue_type)
    end
  end

  member_action :reposition, method: :post do
    item = CashQueue.find(params[:id])
    next_item = params[:next_id] && CashQueue.find(params[:next_id].split('_').last)
    prev_item = params[:prev_id] && CashQueue.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_item.position + 100000
               elsif params[:next_id].blank?
                 prev_item.position / 2
               else
                 (prev_item.position + next_item.position) / 2
               end
    item.update(position: position)
  end
end
