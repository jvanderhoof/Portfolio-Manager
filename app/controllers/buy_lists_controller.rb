class BuyListsController < ApplicationController
  before_filter :authenticate

  def create
    buy_list = BuyList.create(params[:buy_list])
    total_cost = buy_list.buy_list_assets.inject(0){|sum, bla| sum += bla.share_count * bla.share_price}
    available_funds = (buy_list.investment_plan.buy_lists.length == 1) ? buy_list.investment_plan.initial_contribution : buy_list.investment_plan.contribution_amount
    buy_list.investment_plan.update_attribute(:banked_value, buy_list.investment_plan.banked_value.to_f + available_funds - total_cost)
    redirect_to investment_plan_path(buy_list.investment_plan_id), :notice => 'Buy List was marked as purchased.'
  end
end
