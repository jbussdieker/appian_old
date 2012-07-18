class Repository < ActiveRecord::Base
  attr_accessible :description, :name
  before_create :create_repo
  before_destroy :delete_repo

  belongs_to :user

  def create_repo
    FileUtils.mkdir_p(File.join(Rails.root, "repositories", user.name))
    FileUtils.cp_r(File.join(Rails.root, "templates", "blank"), dirname)
    #`cd #{@repository.dirname} && git init --bare`
    #Git.init(@repository.dirname, :bare).write_tree
  end

  def delete_repo
    FileUtils.rm_rf(dirname)
  end

  def dirname
    File.join(Rails.root, "repositories", user.name, name)
  end

  def g
    @g = Git.open("/tmp", :repository => dirname) || @g
  end

  def branches
    g.branches
  end

  def get_blob(rev, file)
    begin
      g.cat_file("#{rev}:#{file}")
    rescue
      nil
    end
  end

  def get_commit(rev)
    begin
      g.gcommit(rev.strip)
    rescue
      nil
    end
  end

  def commits(branch="master")
    revs = g.log(20).skip(0)
    revs.each {|rev|
      get_commit(rev)
    }
  end

  def get_tree(rev)
    begin
      g.ls_tree(rev)
    rescue
      nil
    end
  end

  def files(branch="master", path="")
    path += "/" unless path==""
    r = get_tree("refs/heads/#{branch}:#{path}")
    if r
      return r
    end
    get_tree("#{branch}:#{path}")
  end
end

