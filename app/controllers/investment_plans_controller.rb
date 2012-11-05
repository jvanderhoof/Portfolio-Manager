class InvestmentPlansController < ApplicationController
  before_filter :authenticate
  
  # GET /investment_plans
  # GET /investment_plans.json
  def index
    @investment_plans = (current_user) ? current_user.investment_plans : []

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @investment_plans }
    end
  end

  # GET /investment_plans/1
  # GET /investment_plans/1.json
  def show
    @investment_plan = InvestmentPlan.find(params[:id])
    if @investment_plan.user_id.blank? || (current_user && @investment_plan.user_id == current_user.id)
      contribution_amount = (@investment_plan.initial_contribution == 0 || @investment_plan.buy_lists.length > 0) ? @investment_plan.contribution_amount : @investment_plan.initial_contribution
      @buy_list = BuyList.buy_list_with_assets(@investment_plan.id, @investment_plan.portfolio.portfolio_hash, contribution_amount + @investment_plan.banked_value)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @investment_plan }
      end
    else
      redirect_to new_investment_plan_path, :notice => "You don't have permission to access that Investment Plan"
    end
  end

  # GET /investment_plans/new
  # GET /investment_plans/new.json
  def new
    @investment_plan = InvestmentPlan.new({:portfolio_id => params[:portfolio_id].to_i})
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @investment_plan }
    end
  end

  # GET /investment_plans/1/edit
  def edit
    @investment_plan = InvestmentPlan.find(params[:id])
    unless @investment_plan.user_id.blank? || (current_user && @investment_plan.user_id == current_user.id)
      redirect_to new_investment_plan_path, :notice => "You don't have permission to access that Investment Plan"
    end
  end

  # POST /investment_plans
  # POST /investment_plans.json
  def create
    params[:investment_plan][:user_id] = current_user.id if current_user
    portfolio = Portfolio.find(params[:investment_plan][:portfolio_id])
    if portfolio.template? || (current_user && portfolio.user_id == current_user.id)
      if portfolio.template?
        params[:investment_plan][:portfolio_id] = portfolio.clone(current_user.id).id
      end
      @investment_plan = InvestmentPlan.new(params[:investment_plan])
      @investment_plan.start_date = Date.strptime(params[:investment_plan][:start_date], '%m/%d/%Y') unless params[:investment_plan][:start_date].blank?
      respond_to do |format|
        if @investment_plan.save
          format.html { redirect_to @investment_plan, :notice => 'Investment plan was successfully created.' }
          format.json { render :json => @investment_plan, :status => :created, :location => @investment_plan }
        else
          format.html { render :action => "new" }
          format.json { render :json => @investment_plan.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to new_investment_plan_path, :notice => "You don't have permission to access that Portfolio"
    end
  end

  # PUT /investment_plans/1
  # PUT /investment_plans/1.json
  def update
    @investment_plan = InvestmentPlan.find(params[:id])
    portfolio = Portfolio.find(params[:investment_plan][:portfolio_id])
    if (@investment_plan.user_id.blank? || (current_user && @investment_plan.user_id == current_user.id)) && (portfolio.template? || (current_user && portfolio.user_id == current_user.id))      
      @investment_plan.start_date = Date.strptime(params[:investment_plan].delete(:start_date), '%m/%d/%Y') unless params[:investment_plan][:start_date].blank?
      respond_to do |format|
        if @investment_plan.update_attributes(params[:investment_plan])
          format.html { redirect_to @investment_plan, :notice => 'Investment plan was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @investment_plan.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to new_investment_plan_path, :notice => "You don't have permission to access that Investment Plan"
    end
  end

  # DELETE /investment_plans/1
  # DELETE /investment_plans/1.json
  def destroy
    @investment_plan = InvestmentPlan.find(params[:id])
    if current_user && @investment_plan.user_id == current_user.id
      @investment_plan.destroy

      respond_to do |format|
        format.html { redirect_to investment_plans_url }
        format.json { head :ok }
      end
    else
      redirect_to new_investment_plan_path, :notice => "You don't have permission to access that Investment Plan"
    end
  end
end
