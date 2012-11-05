class InvestmentAssetCategory < ActiveRecord::Base
  has_many :investment_asset_category_plans
  belongs_to :parent, :class_name => 'InvestmentAssetCategory'
  has_many :children, :class_name => 'InvestmentAssetCategory', :primary_key => 'id', :foreign_key => 'parent_id'
end
