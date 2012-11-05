class Balancer

  # ages => array
  #incomes => array of hashes [{:income, :match, :has_401k => true/false}]
  def self.allocation(ages, incomes, filing_type, investment_percentage, tax_rate)
    total_income = incomes.inject(0){|result, i| result += i[:income].to_f}
    investment_amount = (total_income * investment_percentage).to_f
    rtn = ages.map{|i| {:a_401k => 0.0, :roth_ira => 0.0, :ira => 0.0, :investments => 0.0} }
    ages.each_with_index do |age, index|
      if incomes[index][:match] > 0 && incomes[index][:has_401k]
        amount = incomes[index][:match] * incomes[index][:income]
        this_investment_amount = incomes[index][:income] * investment_percentage
        if amount > this_investment_amount
          rtn[index][:a_401k] += this_investment_amount
          investment_amount -= this_investment_amount
        else
          rtn[index][:a_401k] += amount
          investment_amount -= amount
        end
      end
    end
    return rtn if investment_amount.as_currency == 0
    ages.each_with_index do |age, index|
      roth_contribution = roth_ira_contribution_amount([age], [incomes[index][:income]], incomes.inject(0){|t, i| t += i[:income]}, filing_type).first
      unless roth_contribution.round == 0
        post_tax_investment_amount = (investment_amount * (1 - tax_rate)).as_currency
        if roth_contribution > post_tax_investment_amount
          rtn[index][:roth_ira] += post_tax_investment_amount
          investment_amount -= investment_amount
        else
          roth_contribution_pre_tax = ((roth_contribution/(1-tax_rate) * 100).ceil/100.0).as_currency
          rtn[index][:roth_ira] += roth_contribution
          investment_amount -= roth_contribution_pre_tax
        end
      else
        ira_contribution = (age < 50) ? 5_000 : 6_000
        if ira_contribution > investment_amount
          rtn[index][:ira] += investment_amount
          investment_amount -= investment_amount
        else
          rtn[index][:ira] += ira_contribution
          investment_amount -= ira_contribution
        end
      end
      investment_amount = investment_amount.as_currency
    end
    return rtn if investment_amount.as_currency == 0
    ages.each_with_index do |age, index|
      if incomes[index][:has_401k]
        a_401k_amount_remaining = (age < 50) ? 17_000 - rtn[index][:a_401k] : 22_500 - rtn[index][:a_401k]
        if a_401k_amount_remaining > investment_amount
          rtn[index][:a_401k] += investment_amount
          investment_amount -= investment_amount
        else
          rtn[index][:a_401k] += a_401k_amount_remaining
          investment_amount -= a_401k_amount_remaining
        end
        investment_amount = investment_amount.as_currency
      end
    end
    if investment_amount.as_currency > 0
      rtn.first[:investments] += (investment_amount * (1 - tax_rate)).as_currency
    end
    rtn
  end
    
  def self.roth_ira_contribution_amount(ages, incomes, total, filing_type)
    total_amount = []    
    total_income = incomes.inject(0){|result, i| result += i}
    return ages.map{|a| 0} if (total > 183_000 && filing_type == :joint) || (total > 125_000 && filing_type == :single)
    ages.each_with_index do |age, index|
      total_amount << roth_ira_individual(age, total_income, filing_type).as_currency
    end
    total_amount
  end
  
  def self.roth_ira_individual(age, income, filing_type)
    potential_amount = (age < 50) ? 5_000 : 6_000
    if filing_type == :joint
      return potential_amount if income <= 173_000
      percent = (income - 173_000)/10_000.to_f
      return percent * potential_amount
    else
      return potential_amount if income <= 110_000
      percent = (income - 110_000)/15_000.to_f
      return percent * potential_amount
    end
  end
  
end