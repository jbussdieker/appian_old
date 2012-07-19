module ApplicationHelper
  def timediff(time)
    diff = Time.now - time
    return "#{diff.to_i} second" if diff.to_i < 2
    return "#{diff.to_i} seconds" if diff < 60
    diff /= 60
    return "#{diff.to_i} minute" if diff.to_i < 2
    return "#{diff.to_i} minutes" if diff < 60
    diff /= 60
    return "#{diff.to_i} hour" if diff.to_i < 2
    return "#{diff.to_i} hours" if diff < 24
    diff /= 24
    return "#{diff.to_i} day" if diff.to_i < 2
    return "#{diff.to_i} days" if diff < 365
    diff /= 365
    return "#{diff.to_i} year" if diff.to_i < 2
    return "#{diff.to_i} years"
  end

  def user_icon_tag user
    elem_class = "user-menu-icon"
    if user.image
      tag(:img, class: elem_class, src: user.image)
    else
      elem_class << "icon-user"
      tag(:i, class: elem_class)
    end
  end
end
