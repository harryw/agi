class ChefAccountsController < ApplicationController
  # GET /chef_accounts
  # GET /chef_accounts.json
  def index
    @chef_accounts = ChefAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chef_accounts }
    end
  end

  # GET /chef_accounts/1
  # GET /chef_accounts/1.json
  def show
    @chef_account = ChefAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chef_account }
    end
  end

  # GET /chef_accounts/new
  # GET /chef_accounts/new.json
  def new
    @chef_account = ChefAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chef_account }
    end
  end

  # GET /chef_accounts/1/edit
  def edit
    @chef_account = ChefAccount.find(params[:id])
  end

  # POST /chef_accounts
  # POST /chef_accounts.json
  def create
    @chef_account = ChefAccount.new(params[:chef_account])

    respond_to do |format|
      if @chef_account.save
        format.html { redirect_to @chef_account, notice: 'Chef account was successfully created.' }
        format.json { render json: @chef_account, status: :created, location: @chef_account }
      else
        format.html { render action: "new" }
        format.json { render json: @chef_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chef_accounts/1
  # PUT /chef_accounts/1.json
  def update
    @chef_account = ChefAccount.find(params[:id])

    respond_to do |format|
      if @chef_account.update_attributes(params[:chef_account])
        format.html { redirect_to @chef_account, notice: 'Chef account was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @chef_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chef_accounts/1
  # DELETE /chef_accounts/1.json
  def destroy
    @chef_account = ChefAccount.find(params[:id])
    @chef_account.destroy

    respond_to do |format|
      format.html { redirect_to chef_accounts_url }
      format.json { head :ok }
    end
  end
end
