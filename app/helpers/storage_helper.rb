module StorageHelper
  def parent_path(bucket, path)
    if path == ""
      storage_index_path
    else
      storage_path(bucket.name) + "/" + path.split("/")[0..-2].join("/")
    end
  end
end
