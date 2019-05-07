ActiveAdmin.register CashQueue do
  belongs_to :cash_game
  permit_params :small_blind, :big_blind, :table_numbers, :members, :buy_in, :table_no, :table_people, :high_limit, :notice

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
      render :index
    end

    def update
      @cash_queue.update_attributes(user_params)
      render :index
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
            .permit(:small_blind, :big_blind, :table_numbers, :members, :buy_in, :table_no, :table_people, :high_limit, :notice)
    end
  end
end
