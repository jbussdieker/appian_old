module DeviseHelper
  def devise_error_messages!
    msgs = ""
    resource.errors.full_messages.each do |msg|
      msgs << content_tag(:div, "", class: "alert alert-error") do |t|
        concat(content_tag(:a, "&#215;".html_safe, class: "close", "data-dismiss" => "alert"))
        concat(content_tag :div, msg) if msg.is_a?(String)
      end
    end
    msgs.html_safe
  end
end
