class RepositoriesController < ApplicationController
  before_filter :authenticate_user!

  def read_repo
    @repository = Repository.find(params[:id])
    @path = params[:path] || ""
    @branch = params[:branch] || "master"

    begin
      @branches = @repository.branches
    rescue
      @branches = []
      return false
    end

    # Existing Repo
    @commit = @repository.get_commit(@branch)
    @files = @repository.files(@branch, @path)

    return true
  end

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = current_user.repositories.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @repositories }
    end
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
    read_repo
    if @branches.count < 1
      render :template => 'repositories/newrepo'
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/commits/master
  # GET /repositories/1/commits/master.json
  def commits
    read_repo
    if @branches.count < 1
      render :template => 'repositories/newrepo'
      return
    end

    @commits = @repository.commits(@branch)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/commit/master
  # GET /repositories/1/commit/master.json
  def commit
    read_repo
    if @branches.count < 1
      render :template => 'repositories/commit'
      return
    end

    params[:action] = "commit"

    blank_hash = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"
    @commit = @repository.get_commit(@branch)
    @parent = @commit.parent
    @parent = @repository.get_commit(blank_hash) if @parent == nil

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/tree/master
  # GET /repositories/1/tree/master.json
  def tree
    read_repo
    if @branches.count < 1
      render :template => 'repositories/newrepo'
      return
    end

    @files = @repository.files(@branch, @path)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/blob/master
  # GET /repositories/1/blob/master.json
  def blob
    read_repo
    if @branches.count < 1
      render :template => 'repositories/newrepo'
      return
    end

    params[:action] = "blob"

    @blob = @repository.get_blob(@branch, @path)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/new
  # GET /repositories/new.json
  def new
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/edit
  def edit
    @repository = Repository.find(params[:id])
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = current_user.repositories.new(params[:repository])

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render json: @repository, status: :created, location: @repository }
      else
        format.html { render action: "new" }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.json
  def update
    @repository = Repository.find(params[:id])

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to repositories_path }
      format.json { head :no_content }
    end
  end
end
