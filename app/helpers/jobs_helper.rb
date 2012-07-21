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

  def last_failure(job)
    last_build = job.build_info["lastFailedBuild"]
    return if !last_build
    last_build_num = last_build["number"]
    last_details = job.build_details(last_build_num)
    return if !last_details
    td = timediff(Time.at(last_details["timestamp"].to_i / 1000), :short)
    "#{td} (##{last_build_num})"
  end

  def last_success(job)
    last_build = job.build_info["lastSuccessfulBuild"]
    return if !last_build
    last_build_num = last_build["number"]
    last_details = job.build_details(last_build_num)
    return if !last_details
    td = timediff(Time.at(last_details["timestamp"].to_i / 1000), :short)
    "#{td} (##{last_build_num})"
  end

  def last_build_duration(job)
    last_build = job.build_info["lastBuild"]
    return if !last_build
    last_build_num = last_build["number"]
    last_details = job.build_details(last_build_num)
    return if !last_details
    "#{last_details["duration"]} ms"
  end
end
