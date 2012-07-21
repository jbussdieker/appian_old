module ApplicationHelper
  def timediff(time, mode=:long)
    units = {
      short: ["sec", "min", "hr", "yr"], 
      long: ["second", "minute", "hour", "year"],
    }
    diff = Time.now - time
    return pluralize(diff.to_i, units[mode][0]) if diff < 60
    diff /= 60
    return pluralize(diff.to_i, units[mode][1]) if diff < 60
    diff /= 60
    return pluralize(diff.to_i, units[mode][2]) if diff < 24
    diff /= 24
    return pluralize(diff.to_i, units[mode][3]) if diff < 365
    diff /= 365
    return pluralize(diff.to_i, units[mode][4])
  end

  def user_icon_tag user
    if user.image
      content_tag(:img, "", class: "user-menu-icon", src: user.image)
    else
      content_tag(:i, "", class: "icon-user")
    end
  end

end
