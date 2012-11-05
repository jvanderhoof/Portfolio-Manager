class InvestmentAccount < ActiveRecord::Base
  attr_accessor :is_saved
  
  belongs_to :investment_account_type
  belongs_to :person
  belongs_to :investment_account_company

  has_many :investment_asset_investment_accounts, :dependent => :destroy
  has_many :investment_assets, :through => :investment_asset_investment_accounts

  validates :investment_account_type_id, :presence => true 
  
  after_save :set_available_funds
  
  def set_available_funds
    if self.is_saved.blank? || !self.is_saved == true
      self.investment_assets = []
      self.available_funds.split(/\s|,/).each do |symbol|
        next if symbol.strip.blank?
        investment_asset = InvestmentAsset.find_or_create_by_symbol({:symbol => symbol.strip.upcase})
        self.investment_assets << investment_asset unless investment_assets.include?(investment_asset)
      end
      self.is_saved = true
      self.save
    end
  end
  
  def get_asset(category_id, plan)
    if self.investment_account_company.present?
      options = self.investment_account_company.investment_assets.select{|ia| ia.investment_asset_category_id == category_id}
      if options.blank?
        keep_looping = true
        parent = InvestmentAssetCategory.find(category_id)
        while keep_looping
          options = self.investment_account_company.investment_assets.select{|ia| ia.category_hierarchy.to_s.include?("|#{parent.id}|")}
          if options.blank? && parent.parent.blank?
            return nil
          elsif options.blank?
            parent = parent.parent
          else
            break
          end
        end
      end
    else
      options = self.investment_assets.select{|ia| ia.investment_asset_category_id == category_id}
      if options.blank?
        keep_looping = true
        parent = InvestmentAssetCategory.find(category_id)
        while keep_looping
          options = self.investment_account_company.investment_assets.select{|ia| ia.category_hierarchy.to_s.include?("|#{parent.id}|")}
          if options.blank? && parent.parent.blank?
            return nil
          elsif options.blank?
            parent = parent.parent
          else
            break
          end
        end
      end
    end
    rtn = nil
    unless options.blank?
      rtn = options.sort{|x,y| x.expense_ratio.to_f <=> y.expense_ratio.to_f}.first
    end
    rtn    
  end
  
  def translate_to_asset(category_id, plan, fuzzy_lookup=false)
    if self.investment_account_company.present?
      unless fuzzy_lookup
        options = self.investment_account_company.investment_assets.select{|ia| ia.investment_asset_category_id == category_id}
      else
        options = self.investment_account_company.investment_assets.select{|ia| ia.category_hierarchy.to_s.include?("|#{category_id}|")}
      end
    else
      unless fuzzy_lookup
        options = self.investment_assets.select{|ia| ia.investment_asset_category_id == category_id}
      else
        options = self.investment_assets.select{|ia| ia.category_hierarchy.to_s.include?("|#{category_id}|")}
      end
    end
    rtn = nil
    unless options.blank?
      rtn = options.sort{|x,y| x.expense_ratio.to_f <=> y.expense_ratio.to_f}.first
    end
    rtn
  end
  
  def translate_to_assets(plan)
    rtn = {:available => {}, :alternative => {}}
    plan.investment_asset_category_plans.each do |category|
      option = translate_to_asset(category.investment_asset_category_id, plan)
      unless option.blank?
        rtn[:available][category.investment_asset_category_id] = option.id
      else
        next if category.investment_asset_category.parent_id.blank?
        still_blank = true
        parent_category = category.investment_asset_category.parent
        while still_blank
          option = translate_to_asset(parent_category.id, plan, true)
          if option.blank?
            if parent_category.parent.blank?
              still_blank = false
            else
              parent_category = parent_category.parent
            end
          else
            rtn[:alternative][option.investment_asset_category_id] = {:asset_id => option.id, :original_category => category.investment_asset_category_id}
            break
          end
        end
      end
    end
    rtn
  end
end
