ActiveAdmin.register CashQueueMember do
  belongs_to :cash_queue
  permit_params :nickname

  form partial: 'form'

  show do
    render 'show', context: self
  end

  controller do
    before_action :set_cash_queue
    before_action :set_cash_queue_member, only: [:edit, :update, :destroy]

    def new
      @cash_queue_member = @cash_queue.cash_queue_members.build
    end

    def set_cash_queue
      @cash_queue = CashQueue.find(params[:cash_queue_id])
    end

    def set_cash_queue_member
      @cash_queue_member = @cash_queue.cash_queue_members.find(params[:id])
    end
  end
end
