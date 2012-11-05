class Plan < ActiveRecord::Base
  belongs_to :user
  
  has_many :investment_asset_category_plans, :order => "allocation_percentage desc"
  
  accepts_nested_attributes_for :investment_asset_category_plans, :allow_destroy => true, :reject_if => lambda {|s| s[:investment_asset_category_id].blank? }
  
  def as_hash
    rtn = {}
    self.investment_asset_category_plans.each do |i|
      rtn[i.investment_asset_category_id] = i.allocation_percentage
    end
    rtn
  end
end
