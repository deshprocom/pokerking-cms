ActiveAdmin.register CashQueueMember do
  belongs_to :cash_queue
  permit_params :nickname, :published
  config.sort_order = 'position_desc'
  actions :all, except: [:new]

  filter :nickname
  filter :created_at

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  # 快捷添加用户的操作
  action_item :add, only: :index do
    cash_queue = CashQueue.find(params[:cash_queue_id])
    link_to '添加成员', add_admin_cash_queue_cash_queue_members_path(cash_queue), remote: true
  end

  collection_action :add, method: [:get, :post] do
    @cash_queue = CashQueue.find(params[:cash_queue_id])
    return render :add unless request.post?
    @cash_queue_members = @cash_queue.cash_queue_members
    nickname = params[:nickname]
    if @cash_queue_members.pluck(:nickname).include?(nickname) || nickname.blank?
      flash[:error] = '用户昵称已存在，请重新输入'
    else
      @cash_queue_members.create(nickname: nickname)
      flash[:notice] = '用户写入成功'
    end
    redirect_to action: :index
  end

  member_action :member_queue_status, method: :post do
    cash_queue_members =  resource.cash_queue.cash_queue_members.position_desc
    index = 0
    cash_queue_members.each_with_index do |v, k|
      if v.eql?(resource)
        index = k
      end
    end
    @infos = {
        nickname: resource.nickname,
        index: index,
        total: cash_queue_members.count
    }
    render :queue_status
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
