ActiveAdmin.register CashQueue do
  belongs_to :cash_game
  permit_params :small_blind, :big_blind, :table_numbers, :members

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

    def set_cash_game
      @cash_game = CashGame.find(params[:cash_game_id])
    end

    def set_cash_queue
      @cash_queue = @cash_game.cash_queues.find(params[:id])
    end
  end
end
