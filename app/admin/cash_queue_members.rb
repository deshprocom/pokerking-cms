ActiveAdmin.register CashQueueMember do
  belongs_to :cash_queue
  permit_params :nickname, :published
  config.sort_order = 'position_desc'

  form partial: 'form'

  index do
    render 'index', context: self
  end

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

  member_action :cancel, method: :post do
    resource.canceled!
    redirect_back fallback_location: admin_cash_queue_cash_queue_members_url(resource.cash_queue), notice: '取消成功'
  end

  member_action :uncancel, method: :post do
    resource.uncanceled!
    redirect_back fallback_location: admin_cash_queue_cash_queue_members_url(resource.cash_queue), notice: '重新排队成功'
  end

  member_action :reposition, method: :post do
    item = CashQueueMember.find(params[:id])
    next_item = params[:next_id] && CashQueueMember.find(params[:next_id].split('_').last)
    prev_item = params[:prev_id] && CashQueueMember.find(params[:prev_id].split('_').last)
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
