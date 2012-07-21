module ApplicationHelper
  def timediff(time)
    diff = Time.now - time
    return pluralize(diff.to_i, "second") if diff < 60
    diff /= 60
    return pluralize(diff.to_i, "minute") if diff < 60
    diff /= 60
    return pluralize(diff.to_i, "hour") if diff < 24
    diff /= 24
    return pluralize(diff.to_i, "day") if diff < 365
    diff /= 365
    return pluralize(diff.to_i, "year")
  end

  def user_icon_tag user
    if user.image
      content_tag(:img, "", class: "user-menu-icon", src: user.image)
    else
      content_tag(:i, "", class: "icon-user")
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
