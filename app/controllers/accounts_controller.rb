class AccountsController < ApplicationController
  before_filter :authenticate
  
  def index
    if current_user.people.blank?
      redirect_to edit_account_path(current_user.id)
    else
      redirect_to account_path(current_user)
    end
  end
  
  def show
    @user = current_user
    @user.accounts_and_investment_assets    
  end
  
  def edit
    @user = current_user
    if @user.people.length == 0
      @user.people.build 
      @user.people.first.name = current_user.name
      @user.people.first.birthday = 35.years.ago
    end
  end
  
  def update
    @user = current_user    
    @user.update_attributes(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to investment_accounts_path, :notice => 'Your information was successfully updated.' }
      else
        format.html { render :action => "edit" }
      end
    end
    
  end
end
