class StorageController < ApplicationController
  before_filter :authenticate_user!

  def index
    s3 = AWS::S3.new(
        :access_key_id => current_user.access_key_id,
        :secret_access_key => current_user.secret_access_key)
    @buckets = s3.buckets
  end

  def show
    s3 = AWS::S3.new(
        :access_key_id => current_user.access_key_id,
        :secret_access_key => current_user.secret_access_key)
    @bucket = s3.buckets[params[:id]]    
    @path = ""
    if params[:path]
      @path = "#{params[:path]}/"
      @objects = @bucket.objects.with_prefix(@path).as_tree
    else
      @objects = @bucket.as_tree
    end
    @directories = @objects.children.select(&:branch?).collect(&:prefix)
    @files = @objects.children.select(&:leaf?).collect(&:key)
    @files = @files[1..-1] if @files.length > 0
  end
end
