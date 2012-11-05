require 'balancer'
require 'allocator'

class User < ActiveRecord::Base
  
  attr_accessor :should_save, :has_partner
  
  has_many :investment_plans
  has_many :portfolios
  has_many :mailable_investment_plans, :class_name => 'InvestmentPlan', :conditions => {:email_updates => true}

  has_one :plan
  has_many :people, :order => 'id'
  accepts_nested_attributes_for :people, :allow_destroy => true

  validates_associated :people
  
  def self.from_omniauth(auth)
    find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
    end
  end
  
  def has_partner
    self.people.length > 1
  end
  
  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
  
  def allocations    
    rtn = {:to_setup => [], :to_allocation => []}
    ages = people.map{|p| age(p.birthday)}
    tax_rate = 0.3
    incomes = []
    people.each do |person|
      match = 0
      if person.a_401k.present?
        match = person.a_401k.match
      end
      incomes << {:income => person.income, :match => match/100.0, :has_401k => person.has_401k}
    end
    filing_type = (people.length == 1) ? :single : :joint
    accounts_and_amounts = Balancer.allocation(ages, incomes, filing_type, self.percent_to_save/100.0, tax_rate)
    accounts_and_amounts.each_with_index do |account_amount, index|
      person = people[index]
      if account_amount[:roth_ira] > 0 || account_amount[:ira] > 0
        ira_type = (account_amount[:roth_ira] > 0) ? :roth_ira : :ira
        ira_title = (ira_type == :roth_ira) ? 'Roth IRA': 'IRA'
        if person.send(ira_type).present?
          rtn[:to_allocation] << {:type => ira_type, :amount => account_amount[ira_type], :title => ira_title, :person => person}
        else
          rtn[:to_setup] << {:type => ira_type, :amount => account_amount[ira_type], :title => ira_title, :person => person}
        end
      end
      if account_amount[:investments] > 0
        investment_account = {:type => :investment, :amount => account_amount[:investments], :title => 'Investement Account', :person => person}
        rtn[:to_allocation] << investment_account
      end
      if account_amount[:a_401k] > 0
        if person.a_401k.present?
          rtn[:to_allocation] << {:type => :a_401k, :amount => account_amount[:a_401k], :title => '401k/403b', :person => person}
        else
          if investment_account.present?
            investment_account[:amount] += (account_amount[:a_401k].to_f * (1 - tax_rate)).as_currency
          else
            rtn[:to_allocation] << {:type => :investment, :amount => (account_amount[:a_401k].to_f * (1 - tax_rate)).as_currency, :title => 'Investment Account', :person => person}
          end
        end
      end
    end
    rtn
  end

  def accounts_and_investment_assets
    accounts = []
    current_allocations = allocations[:to_allocation]
    current_allocations.each do |allocation|
      if allocation[:person].respond_to?(allocation[:type])
        assets = allocation[:person].send(allocation[:type]).translate_to_assets(self.plan) #[:available].keys
        # {:available=>{110=>942, 79=>945}, :alternative=>{107=>938}}
        formatted_asset_categories = {}
        assets[:available].each_pair{|category, asset| formatted_asset_categories[category] = {:available => category}}
        assets[:alternative].each_pair{|category, asset| formatted_asset_categories[asset[:original_category]] = {:alternative => asset[:original_category]}}
        # {1 => {:available => 1}, 2 => {:alternative => 3}}
        accounts << {
          :assets => formatted_asset_categories,
          :total_value => allocation[:amount]
        }
      end
    end
    investments = Allocator.build_portfolios(plan.as_hash, accounts, current_allocations.inject(0){|result,i| result += i[:amount]})
    current_allocations.each_with_index do |allocation, index|
      allocation[:assets] = investments[index]
    end
    current_allocations    
  end
  
end
