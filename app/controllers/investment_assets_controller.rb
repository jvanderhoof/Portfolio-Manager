class InvestmentAssetsController < ApplicationController
  before_filter :authenticate

  # GET /investment_assets
  # GET /investment_assets.json
  def index
    if current_user && current_user.admin?
      @investment_assets = InvestmentAsset.order('name')

      respond_to do |format|
        format.html # index.html.erb
      end
    else
      redirect_to accounts_path
    end
  end

  # GET /investment_assets/1
  # GET /investment_assets/1.json
  def show
    @investment_asset = InvestmentAsset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /investment_assets/new
  # GET /investment_assets/new.json
  def new
    if current_user && current_user.admin?
      @investment_asset = InvestmentAsset.new

      respond_to do |format|
        format.html # new.html.erb
      end
    else
      redirect_to accounts_path
    end
  end

  # GET /investment_assets/1/edit
  def edit
    if current_user && current_user.admin?
      @investment_asset = InvestmentAsset.find(params[:id])
    else
      redirect_to accounts_path
    end
  end

  # POST /investment_assets
  # POST /investment_assets.json
  def create
    if current_user && current_user.admin?
      @investment_asset = InvestmentAsset.new(params[:investment_asset])

      respond_to do |format|
        if @investment_asset.save
          format.html { redirect_to @investment_asset, notice => 'Investment asset was successfully created.' }
        else
          format.html { render :action => "new" }
        end
      end
    else
      redirect_to accounts_path
    end
  end

  # PUT /investment_assets/1
  # PUT /investment_assets/1.json
  def update
    if current_user && current_user.admin?
      @investment_asset = InvestmentAsset.find(params[:id])

      respond_to do |format|
        if @investment_asset.update_attributes(params[:investment_asset])
          format.html { redirect_to({:controller => :investment_assets, :action => :index}, :notice => 'Investment asset was successfully updated.') }
        else
          format.html { render :action => "edit" }
        end
      end
    else
      redirect_to accounts_path
    end      
  end

  # DELETE /investment_assets/1
  # DELETE /investment_assets/1.json
  def destroy
    if current_user && current_user.admin?
      @investment_asset = InvestmentAsset.find(params[:id])
      @investment_asset.destroy

      respond_to do |format|
        format.html { redirect_to investment_assets_url }
        format.json { head :ok }
      end
    else
      redirect_to accounts_path
    end
  end
end
