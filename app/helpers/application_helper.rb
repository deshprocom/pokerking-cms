module ApplicationHelper
  def img_link_to_show(resource, preview)
    link_to image_tag(preview.to_s, height: 150), resource_path(resource)
  end

  def main_event_sidebar_generator(context)
    context.instance_eval do
      ul do
        li link_to 'Schedule', admin_main_event_event_schedules_path(main_event)
        li link_to 'Event News', admin_main_event_infos_path(main_event)
      end
    end
  end

  def cash_queue_sidebar_generator(context)
    context.instance_eval do
      ul do
        li link_to I18n.t('activerecord.models.cash_queue'), admin_cash_game_cash_queues_path(cash_game)
      end
    end
  end

  def queue_member_cancel_link(resource)
    if resource.canceled?
      link_to 'Reorder', uncancel_admin_cash_queue_cash_queue_member_path(resource.cash_queue, resource), method: :post
    else
      link_to 'Order Cancel', cancel_admin_cash_queue_cash_queue_member_path(resource.cash_queue, resource), method: :post
    end
  end

  def avatar(src, options = {})
    html_options = { class: 'img-circle', size: 60 }.merge(options)
    image_tag(src.presence || 'default_avatar.jpg', html_options)
  end
end
