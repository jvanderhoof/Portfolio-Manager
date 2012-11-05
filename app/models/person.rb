class Person < ActiveRecord::Base
  validates :name, :presence => true
  validates :income, :numericality => true
  
  validates_associated :investment_accounts
  
  

  belongs_to :user
  has_many :investment_accounts
  accepts_nested_attributes_for :investment_accounts, :allow_destroy => true
  
  def a_401k
    generic_account_lookup('401k/403b')
  end
  
  def ira
    generic_account_lookup('IRA')
  end
  
  def roth_ira
    generic_account_lookup('Roth IRA')
  end
  
  def investment
    generic_account_lookup('Investment Account')
  end
  
  def account_exists?(name)
    investment_account_type = InvestmentAccountType.where({:name => name}).first
    return false if investment_account_type.blank?
    InvestmentAccount.exists?({:person_id => self.id, :investment_account_type_id => investment_account_type.id})
  end
  
  def generic_account_lookup(name)
    investment_account_type = InvestmentAccountType.where({:name => name}).first
    return nil if investment_account_type.blank?
    rtn = InvestmentAccount.where({:person_id => self.id, :investment_account_type_id => investment_account_type.id}).first   
    if rtn.blank?
      case name
      when 'IRA', 'Roth IRA'
        assets = []
        unless InvestmentAccountCompany.order('id').first.blank?
          assets = InvestmentAccountCompany.order.first.investment_assets
        end
        rtn = InvestmentAccount.new({:person_id => self.id, :investment_account_type => investment_account_type, :investment_assets => assets})
      when 'Investment Account'
        rtn = InvestmentAccount.new({:person_id => self.id, :investment_account_type => investment_account_type, :investment_assets => InvestmentAsset.all})
      end
    end
    rtn
  end
end
