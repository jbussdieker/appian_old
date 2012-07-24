module ServersHelper
  def server_status_badge(server)
    begin
      status = server.status
    rescue Exception => e
      return content_tag(:i, "offline", class: "badge badge-warning")
    end
    if status == :stopped
      content_tag(:i, status, class: "badge")
    elsif status == :running
      content_tag(:i, status, class: "badge badge-success")
    else
      content_tag(:i, "Unknown: #{status}", class: "badge")
    end
  end
end
