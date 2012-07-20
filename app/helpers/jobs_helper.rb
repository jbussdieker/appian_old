module JobsHelper
  def build_status_badge(job)
    begin
      color = job.build_info["color"]
    rescue Exception => e
      return
    end
    if color == "grey"
      content_tag(:i, "", class: "badge")
    elsif color == "red"
      content_tag(:i, "", class: "badge badge-important")
    elsif color == "blue"
      content_tag(:i, "", class: "badge badge-success")
    end
  end
end
