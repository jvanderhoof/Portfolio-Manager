class InvestmentAssetCategoriesController < ApplicationController
  # GET /investment_asset_categories
  # GET /investment_asset_categories.json
  def index
    @investment_asset_categories = InvestmentAssetCategory.order('name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @investment_asset_categories }
    end
  end

  # GET /investment_asset_categories/1
  # GET /investment_asset_categories/1.json
  def show
    @investment_asset_category = InvestmentAssetCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @investment_asset_category }
    end
  end

  # GET /investment_asset_categories/new
  # GET /investment_asset_categories/new.json
  def new
    @investment_asset_category = InvestmentAssetCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @investment_asset_category }
    end
  end

  # GET /investment_asset_categories/1/edit
  def edit
    @investment_asset_category = InvestmentAssetCategory.find(params[:id])
  end

  # POST /investment_asset_categories
  # POST /investment_asset_categories.json
  def create
    @investment_asset_category = InvestmentAssetCategory.new(params[:investment_asset_category])

    respond_to do |format|
      if @investment_asset_category.save
        format.html { redirect_to investment_asset_categories_path, :notice => 'Investment asset category was successfully created.' }
        format.json { render :json => @investment_asset_category, :status => :created, :location => @investment_asset_category }
      else
        format.html { render :action => "new" }
        format.json { render :json => @investment_asset_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /investment_asset_categories/1
  # PUT /investment_asset_categories/1.json
  def update
    @investment_asset_category = InvestmentAssetCategory.find(params[:id])

    respond_to do |format|
      if @investment_asset_category.update_attributes(params[:investment_asset_category])
        format.html { redirect_to investment_asset_categories_path, :notice => 'Investment asset category was successfully created.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @investment_asset_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /investment_asset_categories/1
  # DELETE /investment_asset_categories/1.json
  def destroy
    @investment_asset_category = InvestmentAssetCategory.find(params[:id])
    @investment_asset_category.destroy

    respond_to do |format|
      format.html { redirect_to investment_asset_categories_url }
      format.json { head :ok }
    end
  end
end
