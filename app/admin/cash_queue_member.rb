ActiveAdmin.register CashQueueMember do
  belongs_to :cash_queue
  permit_params :nickname, :published, :memo
  config.sort_order = 'position_desc'
  actions :all, except: [:new]
  config.breadcrumb = false
  config.paginate = false

  filter :nickname

  scope :all
  scope('confirmed') do |scope|
    scope.where(confirmed: true)
  end
  scope('unconfirmed') do |scope|
    scope.where(confirmed: false)
  end

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  controller do
    # def scoped_collection
    #   super.where(confirmed: true)
    # end
    def index
      cash_queue = CashQueue.find(params[:cash_queue_id])
      if !cash_queue.high_limit && !cash_queue.transfer
        @page_title = "Waiting List #{cash_queue.blind_info}"
      else
        string = cash_queue.high_limit ? 'High Limit ' : ''
        @page_title = cash_queue.transfer ? (string + 'Transfer Request') : string
      end
      @page_title = 'Waiting List ' + @page_title
      super
    end

    def destroy
      CashQueueMember.find(params[:id]).destroy
      redirect_to request.referrer
    end

    def queue_params
      params.require(:cash_queue).permit(:small_blind, :big_blind, :members, :buy_in, :table_no, :table_people, :navigation, :notice, :currency, :high_limit, :transfer, :straddle, :position, :queue_type)
    end
  end

  sidebar 'Other Blinds', only: :index do
    cash_queue = CashQueue.find(params[:cash_queue_id])
    cash_game = cash_queue.cash_game
    cash_queues = cash_game.cash_queues.order(small_blind: :asc)
    if !cash_queue.high_limit && !cash_queue.transfer
      str_current = "#{cash_queue.blind_info}"
    else
      string = cash_queue.high_limit ? 'High Limit ' : ''
      str_current = cash_queue.transfer ? (string + 'Transfer Request') : string
    end
    div "#{str_current} [Current]"
    cash_queues.each do |item|
      next if item.eql? cash_queue
      if !item.high_limit && !item.transfer
        str = "#{item.blind_info}"
      else
        string = item.high_limit ? 'High Limit ' : ''
        str = item.transfer ? (string + 'Transfer Request') : string
      end
      div link_to str, admin_cash_queue_cash_queue_members_path(item.id), class: 'queue_blind'
    end
  end

  sidebar :'Link to', only: :index do
    div link_to 'Blinds', admin_cash_game_cash_queues_path(cash_queue.cash_game)
    div link_to 'Rooms', admin_cash_games_path
  end

  # 批量删除操作
  batch_action :destroy, confirm: 'Are you sure?' do |ids|
    CashQueueMember.find(ids).each(&:destroy)
    redirect_to request.referrer
  end

  # 通过用户的报名请求
  member_action :confirmed, method: [:post] do
    cash_queue_member = CashQueueMember.find(params[:id])
    cash_queue_member.update(confirmed: true)
    # 下发app通知消息
    Notification.create_queue_notify(cash_queue_member&.user, cash_queue_member.cash_queue)
    redirect_to request.referrer
  end

  # 快捷添加用户的操作
  action_item :add, only: :index do
    cash_queue = CashQueue.find(params[:cash_queue_id])
    link_to I18n.t("sidebars.add"), add_admin_cash_queue_cash_queue_members_path(cash_queue), remote: true
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
      flash[:error] = I18n.t("notices.username_blank")
    elsif flag
      flash[:error] = I18n.t("notices.username_exist_in_blinds") + ": #{error_strs.join(', ')}"
    else
      queues.each do |queue|
        queue.cash_queue_members.create(nickname: nickname, memo: params[:memo])
      end
      flash[:notice] = I18n.t("notices.write_access")
    end
    redirect_to request.referrer
  end

  member_action :edit_info, method: [:get, :post] do
    @cash_queue = CashQueue.find(params[:cash_queue_id])
    return render :edit_info unless request.post?
    @cash_queue_members = @cash_queue.cash_queue_members
    nickname = params[:nickname]
    if @cash_queue_members.pluck(:nickname).include?(nickname) || nickname.blank?
      flash[:error] = I18n.t("notices.username_exist")
    else
      resource.update(nickname: nickname, memo: params[:memo])
      flash[:notice] = 'update success'
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
    link_to I18n.t("sidebars.edit_current_blind"), edit_blind_admin_cash_queue_cash_queue_members_path(cash_queue), remote: true
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
    redirect_back fallback_location: admin_cash_queue_cash_queue_members_url(resource.cash_queue), notice: 'Cancel Success'
  end

  member_action :uncancel, method: :post do
    resource.uncanceled!
    redirect_back fallback_location: admin_cash_queue_cash_queue_members_url(resource.cash_queue), notice: 'Reorder Success'
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
