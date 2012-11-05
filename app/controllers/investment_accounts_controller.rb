class InvestmentAccountsController < ApplicationController
  def index
    @user = current_user
    @user.people.each do |person|
      person.investment_accounts.build if person.investment_accounts.blank?
    end
  end
  
  def update
    @user = current_user    
    @user.update_attributes(params[:user])
    respond_to do |format|
      if @user.save
        if @user.plan.blank?
          format.html { redirect_to plans_path, :notice => 'Accounts were successfully updated.' }
        else 
          format.html { redirect_to account_path(@user), :notice => 'Accounts were successfully updated.' }
        end
      else
        format.html { render :action => "edit" }
      end
    end
    
  end
  
end
