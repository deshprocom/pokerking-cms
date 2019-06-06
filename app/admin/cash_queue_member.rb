ActiveAdmin.register CashQueueMember do
  belongs_to :cash_queue
  permit_params :nickname, :published, :memo
  config.sort_order = 'position_desc'
  actions :all, except: [:new]
  config.breadcrumb = false
  config.paginate = false

  filter :nickname

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  controller do
    def index
      cash_queue = CashQueue.find(params[:cash_queue_id])
      @page_title = cash_queue.high_limit ? '排队列表 High Limit' : "排队列表 #{cash_queue.small_blind} / #{cash_queue.big_blind}"
      super
    end

    def queue_params
      params.require(:cash_queue).permit(:small_blind, :big_blind, :members, :buy_in, :table_no, :table_people, :navigation, :notice, :high_limit)
    end
  end

  sidebar :'盲注结构列表', only: :index do
    cash_queue = CashQueue.find(params[:cash_queue_id])
    cash_game = cash_queue.cash_game
    cash_queues = cash_game.cash_queues.order(small_blind: :asc)
    str_current = cash_queue.high_limit ? 'High Limit' : ("#{cash_queue.small_blind} / #{cash_queue.big_blind}")
    div "#{str_current} [current]"
    cash_queues.each do |item|
      next if item.eql? cash_queue
      str = item.high_limit ? 'High Limit' : "#{item.small_blind} / #{item.big_blind}"
      div link_to str, admin_cash_queue_cash_queue_members_path(item.id), class: 'queue_blind'
    end
  end

  sidebar :'相关链接', only: :index do
    div link_to '查看盲注列表', admin_cash_game_cash_queues_path(cash_queue.cash_game)
    div link_to '查看现金桌列表', admin_cash_games_path
  end

  # 快捷添加用户的操作
  action_item :add, only: :index do
    cash_queue = CashQueue.find(params[:cash_queue_id])
    link_to '添加成员', add_admin_cash_queue_cash_queue_members_path(cash_queue), remote: true
  end

  collection_action :add, method: [:get, :post] do
    @cash_queue = CashQueue.find(params[:cash_queue_id])
    @queue_lists = @cash_queue.cash_game.cash_queues
    return render :add unless request.post?
    nickname = params[:nickname]
    # 检查想要保存的queues里面是否有这个昵称，有的话不给添加，没有的话可以添加
    queues = CashQueue.find(params[:queues])
    flag = false
    error_strs = []
    queues.each do |queue|
      if queue.cash_queue_members.pluck(:nickname).include?(nickname)
        flag = true
        error_strs.push("#{queue.small_blind}/#{queue.big_blind}")
      end
    end
    if nickname.blank?
      flash[:error] = "用户昵称不能为空，请重新输入."
    elsif flag
      flash[:error] = "用户昵称已存在，请重新输入. 存在的盲注结构有： #{error_strs.join(', ')}"
    else
      queues.each do |queue|
        queue.cash_queue_members.create(nickname: nickname, memo: params[:memo])
      end
      flash[:notice] = '用户写入成功'
    end
    redirect_to request.referrer
    # redirect_back fallback_location: admin_cash_queue_cash_queue_members_url(), notice: '上热门成功'
  end

  member_action :edit_info, method: [:get, :post] do
    @cash_queue = CashQueue.find(params[:cash_queue_id])
    return render :edit_info unless request.post?
    @cash_queue_members = @cash_queue.cash_queue_members
    nickname = params[:nickname]
    if @cash_queue_members.pluck(:nickname).include?(nickname) || nickname.blank?
      flash[:error] = '用户昵称已存在，请重新输入'
    else
      resource.update(nickname: nickname, memo: params[:memo])
      flash[:notice] = '用户昵称修改成功'
    end
    # redirect_to action: :index
    redirect_to request.referrer
  end

  member_action :member_queue_status, method: :post do
    cash_queue_members =  resource.cash_queue.cash_queue_members.position_asc
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

  # 快捷添加用户的操作
  action_item :edit_blind, only: :index do
    cash_queue = CashQueue.find(params[:cash_queue_id])
    link_to '修改当前盲注', edit_blind_admin_cash_queue_cash_queue_members_path(cash_queue), remote: true
  end

  collection_action :edit_blind, method: [:get, :post] do
    @cash_queue = CashQueue.find(params[:cash_queue_id])
    return render :edit_blind unless request.post?
    @cash_queue.update_attributes(queue_params)
    # redirect_to action: :index
    redirect_to request.referrer
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
