class PurchaseMailer < ActionMailer::Base
  default :from => "jvanderhoof@gmail.com"
  
  def purchase_list(investment_plan)
    if investment_plan.initial_contribution == 0 || investment_plan.buy_lists.length > 0
      contribution_amount = investment_plan.contribution_amount
    else 
      contribution_amount = investment_plan.initial_contribution
    end
    @buy_list = BuyList.buy_list_with_assets(investment_plan.id, investment_plan.portfolio.portfolio_hash, contribution_amount + investment_plan.banked_value)
    @investment_plan = investment_plan
    subject = "Your Purchase List"
    subject += " for #{investment_plan.name}" unless investment_plan.name.blank?
    mail(:to => investment_plan.user.email, :subject => subject)
  end
end
