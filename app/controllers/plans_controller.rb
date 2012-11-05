class PlansController < ApplicationController
  def index
    if current_user.plan.blank?
      redirect_to new_plan_path
    else
      redirect_to edit_plan_path(current_user.plan)
    end
  end
  
  def new
    @plan = Plan.new
    #@plan.investment_asset_category_plans << InvestmentAssetCategoryPlan.new({:investment_asset_category_id => InvestmentAssetCategory.find_by_name('Large Blend').id, :allocation_percentage => 34})
    #@plan.investment_asset_category_plans << InvestmentAssetCategoryPlan.new({:investment_asset_category_id => InvestmentAssetCategory.find_by_name('Foreign Large Blend').id, :allocation_percentage => 33})
    #@plan.investment_asset_category_plans << InvestmentAssetCategoryPlan.new({:investment_asset_category_id => InvestmentAssetCategory.find_by_name('Inflation-Protected Bond').id, :allocation_percentage => 33})
  end
  
  def edit
    @plan = current_user.plan
  end
  
  def create
    @plan = Plan.new(params[:plan].merge({:user_id => current_user.id}))
    respond_to do |format|
      if @plan.save        
        format.html { redirect_to accounts_path, :notice => 'Plan was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @plan = Plan.find(params[:id])
    @plan.update_attributes(params[:plan].merge({:user_id => current_user.id}))
    respond_to do |format|
      if @plan.save        
        format.html { redirect_to accounts_path, :notice => 'Plan was successfully created.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
end
