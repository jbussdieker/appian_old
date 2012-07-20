module JobsHelper
  def build_status_badge(job)
    begin
      color = job.build_info["color"]
    rescue Exception => e
      content_tag(:i, "", class: "badge badge-warning")
    end
    if color == "grey"
      content_tag(:i, "idle", class: "badge")
    elsif color == "red"
      content_tag(:i, "idle", class: "badge badge-important")
    elsif color == "blue"
      content_tag(:i, "idle", class: "badge badge-success")
    elsif color == "red_anime"
      content_tag(:i, "running", class: "badge badge-important")
    elsif color == "blue_anime"
      content_tag(:i, "running", class: "badge badge-important")
    else
      content_tag(:i, "#{color}", class: "badge badge-success")
    end
  end
end
