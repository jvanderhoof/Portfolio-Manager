class PortfoliosController < ApplicationController
  before_filter :authenticate

  # GET /portfolios
  # GET /portfolios.json
  def index
    if current_user
      @portfolios = Portfolio.where(["template = ? or user_id = ?", true, current_user.id])
    else
      @portfolios = Portfolio.where(["template = ?", true])      
    end
    
    historical = {}
    historical_data = @portfolios.map{|p| p.historical(10)[:data]}
    #portfolio_names = @portfolios.map{|p| p.historical(10)[:data]}
    historical_data.each_with_index do |portfolio, index|
      portfolio.each do |buy_item|
        #raise buy_item.inspect
        historical[buy_item[:date]] ||= {}
        historical[buy_item[:date]][@portfolios[index].name] = buy_item[:value]
      end
      #raise portfolio.inspect
    end
    
    names = ['Date', 'Cost']
    historical_values = []
    cost = 0
    historical.keys.sort.each do |date|
      cost += 500
      row = ["'#{date.strftime('%m/%d/%Y')}'", cost.to_s]
      historical[date].each_pair do |key, value|
        names << key unless names.include?(key)
        row << historical[date][key]
      end
      historical_values << "[#{row.join(",")}]"
    end
    names = names.map{|n| "'#{n}'"}
    historical_values.insert(0, names)
    #['Date', 'Value', 'Cost'],
#<%= @portfolio.historical(10)[:data].map{|row| "['#{row[:date]}', #{row[:value]}, #{row[:cost]}]"}.join(',') %>
    
    #@portfolios.each do |portfolio|
    #  names << portfolio.name
    #  historical << portfolio.historical(10)[:data].map{|row| "['#{row[:date]}', #{row[:value]}, #{row[:cost]}]"}.join(',')
    #end
    
    @graph_formatted = "[#{historical_values.join(',')}]"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @portfolios }
    end
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
    @portfolio = Portfolio.find(params[:id])
    if @portfolio.template || (current_user && @portfolio.user_id == current_user.id)
      @total_value = @portfolio.portfolio_assets.inject(0){|sum, i| sum + i.shares * i.current_value}
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @portfolio }
      end
    else
      redirect_to portfolios_path, :notice => "You don't have permission to access that Portfolio"
    end
  end

  # GET /portfolios/new
  # GET /portfolios/new.json
  def new
    @portfolio = Portfolio.new
    @portfolio.user_id = current_user.id if current_user.present?
    @action = 'Create'
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @portfolio }
    end
  end

  # GET /portfolios/1/edit
  def edit
    @portfolio = Portfolio.includes(:portfolio_assets).find(params[:id])
    if current_user && @portfolio.user_id == current_user.id
      @action = 'Update'    
    else
      redirect_to portfolios_path, :notice => "You don't have permission to access that Portfolio"
    end
  end

  # POST /portfolios
  # POST /portfolios.json
  def create
    @portfolio = Portfolio.new(params[:portfolio])

    respond_to do |format|
      if @portfolio.save
        format.html { redirect_to @portfolio, :notice => 'Portfolio was successfully created.' }
        format.json { render :json => @portfolio, :status => :created, :location => @portfolio }
      else
        format.html { render :action => "new" }
        format.json { render :json => @portfolio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /portfolios/1
  # PUT /portfolios/1.json
  def update
    @portfolio = Portfolio.find(params[:id])
    if current_user && @portfolio.user_id == current_user.id
      respond_to do |format|
        if @portfolio.update_attributes(params[:portfolio])
          format.html { redirect_to @portfolio, :notice => 'Portfolio was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @portfolio.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to portfolios_path, :notice => "You don't have permission to access that Portfolio"
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy    
    @portfolio = Portfolio.find(params[:id])
    if current_user && @portfolio.user_id == current_user.id
      if @portfolio.investment_plan.present?
        redirect_to portfolio_path(@portfolio), :notice => "You have and Investment Plan that uses the portfolio: #{@portfolio.name}"
      else
        @portfolio.destroy

        respond_to do |format|
          format.html { redirect_to portfolios_url }
          format.json { head :ok }
        end
      end
    else
      redirect_to portfolios_path, :notice => "You don't have permission to access that Portfolio"
    end
  end
  
end
