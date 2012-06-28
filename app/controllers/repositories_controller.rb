class RepositoriesController < ApplicationController
  before_filter :authenticate_user!

  def create_repo
    FileUtils.mkdir_p(@repository.dirname)
    `cd #{@repository.dirname} && git init --bare`
  end

  def delete_repo
    FileUtils.rm_rf(@repository.dirname)
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
    @repository = Repository.find_by_name(params[:repository])
    @commit = @repository.latest_commit(params[:branch] || "master")
    @branch = params[:branch] || "master"
    @path = params[:path] || ""
    @files = @repository.files(@branch, @path)
    params[:action] = "tree"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/commits/master
  # GET /repositories/1/commits/master.json
  def commits
    @repository = Repository.find_by_name(params[:repository])
    @branch = params[:branch] || "master"
    @commits = @repository.commits(@branch)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/tree/master
  # GET /repositories/1/tree/master.json
  def tree
    @repository = Repository.find_by_name(params[:repository])
    @branch = params[:branch] || "master"
    @path = params[:path] || ""
    @files = @repository.files(@branch, @path)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repository }
    end
  end

  # GET /repositories/1/blob/master
  # GET /repositories/1/blob/master.json
  def blob
    @repository = Repository.find_by_name(params[:repository])
    @branch = params[:branch] || "master"
    @path = params[:path]
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
    create_repo

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
    delete_repo
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to repositories_url }
      format.json { head :no_content }
    end
  end
end
