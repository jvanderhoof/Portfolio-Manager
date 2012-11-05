class InvestmentAccountCompaniesController < ApplicationController
  # GET /investment_account_companies
  # GET /investment_account_companies.json
  def index
    @investment_account_companies = InvestmentAccountCompany.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /investment_account_companies/1
  # GET /investment_account_companies/1.json
  def show
    @investment_account_company = InvestmentAccountCompany.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /investment_account_companies/new
  # GET /investment_account_companies/new.json
  def new
    @investment_account_company = InvestmentAccountCompany.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /investment_account_companies/1/edit
  def edit
    @investment_account_company = InvestmentAccountCompany.find(params[:id])
  end

  # POST /investment_account_companies
  # POST /investment_account_companies.json
  def create
    @investment_account_company = InvestmentAccountCompany.new(params[:investment_account_company])

    respond_to do |format|
      if @investment_account_company.save
        format.html { redirect_to @investment_account_company, :notice => 'Investment account company was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /investment_account_companies/1
  # PUT /investment_account_companies/1.json
  def update
    @investment_account_company = InvestmentAccountCompany.find(params[:id])

    respond_to do |format|
      if @investment_account_company.update_attributes(params[:investment_account_company])
        format.html { redirect_to @investment_account_company, :notice => 'Investment account company was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /investment_account_companies/1
  # DELETE /investment_account_companies/1.json
  def destroy
    @investment_account_company = InvestmentAccountCompany.find(params[:id])
    @investment_account_company.destroy

    respond_to do |format|
      format.html { redirect_to investment_account_companies_url }
      format.json { head :ok }
    end
  end
end
