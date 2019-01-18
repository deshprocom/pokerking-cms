module ApplicationHelper
  def img_link_to_show(resource, preview)
    link_to image_tag(preview, height: 150), resource_path(resource)
  end
end
