class Repository < ActiveRecord::Base
  attr_accessible :description, :name
  before_create :create_repo
  before_destroy :delete_repo

  belongs_to :user
  has_many :jobs

  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validate :name_format

  default_scope :order => 'name'

  def to_s
    name
  end

  def name_format
    all_valid_characters = name =~ /^[a-zA-Z0-9_\-]+$/
    errors.add(:name, "must contain only letters, digits, dashes, or underscores") unless all_valid_characters
  end

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

  def git
    @git_api = Git.open("/tmp", :repository => dirname) || @git_api
  end

  def branches
    git.branches
  end

  def get_blob(rev, file)
    begin
      git.cat_file("#{rev}:#{file}")
    rescue
      nil
    end
  end

  def get_commit(rev)
    begin
      git.gcommit(rev.strip)
    rescue
      nil
    end
  end

  def commits(branch="master")
    revs = git.log(20).skip(0)
    revs.each {|rev|
      get_commit(rev)
    }
  end

  def get_tree(rev)
    begin
      git.ls_tree(rev)
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

