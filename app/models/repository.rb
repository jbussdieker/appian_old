class Repository < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :user

  def dirname
    File.join(Rails.root, "repositories", user.name, name)
  end

  def branches
    refdir = File.join(dirname, "refs/heads/*")
    dirs = Dir[refdir].map { |a| File.basename(a) }
    puts dirs
    dirs
  end

  def get_blob(rev, file)
    logger.info "#{rev} #{file}"
    blob = `cd #{dirname} && git show #{rev}:#{file}`
    {
      blob: blob,
      file: file,
      hash: rev,
    }
  end

  def get_commit(rev)
    author = `cd #{dirname} && git show -s --format=%an #{rev}`
    subject = `cd #{dirname} && git show -s --format=%s #{rev}`
    {
      author: author,
      subject: subject,
      hash: rev,
    }
  end

  def get_tree(rev)
    tree = `cd #{dirname} && git ls-tree #{rev}`
    tree.split("\n").map {|file|
      mode, type, hash, name = file.split(" ")
      {
        mode: mode,
        type: type,
        hash: hash,
        name: File.basename(name),
      }
    }.sort_by { |item| [item[:name]] }.sort{|a,b| b[:type] <=> a[:type] }
#sort_by { |item| [item[:name]] }.sort_by { |item| [item[:type]] }
  end

  def latest_commit(branch="master")
    rev = `cd #{dirname} && git rev-list refs/heads/#{branch} --date-order --max-count=1`
    get_commit(rev)
  end

  def commits(branch="master")
    revs = `cd #{dirname} && git rev-list refs/heads/#{branch} --date-order --max-count=20`
    revs.split("\n").map {|rev|
      get_commit(rev)
    }
  end

  def files(branch="master", path="")
    path += "/" unless path==""
    r = get_tree("refs/heads/#{branch} #{path}")
    if r.count == 0
      r = get_tree("#{branch} #{path}")
    end
    r
  end
end
