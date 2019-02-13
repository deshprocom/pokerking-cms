module ApplicationHelper
  def img_link_to_show(resource, preview)
    link_to image_tag(preview.to_s, height: 150), resource_path(resource)
  end

  def main_event_sidebar_generator(context)
    context.instance_eval do
      ul do
        li link_to '赛程表', admin_main_event_event_schedules_path(main_event)
      end
    end
  end
end
