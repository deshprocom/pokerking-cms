module ApplicationHelper
  def img_link_to_show(resource, preview)
    link_to image_tag(preview.to_s, height: 150), resource_path(resource)
  end

  def main_event_sidebar_generator(context)
    context.instance_eval do
      ul do
        li link_to '赛程表', admin_main_event_event_schedules_path(main_event)
        li link_to '赛事新闻', admin_main_event_event_infos_path(main_event)
      end
    end
  end

  def cash_queue_sidebar_generator(context)
    context.instance_eval do
      ul do
        li link_to '排队进程', admin_cash_game_cash_queues_path(cash_game)
      end
    end
  end

  def queue_member_cancel_link(resource)
    if resource.canceled?
      link_to '重新排队', uncancel_admin_cash_queue_cash_queue_member_path(resource.cash_queue, resource), method: :post
    else
      link_to '取消排队', cancel_admin_cash_queue_cash_queue_member_path(resource.cash_queue, resource), method: :post
    end
  end
end
