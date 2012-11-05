class Allocator

  # pool size - amount available across all account for this allocation
  # allocation_amount - amount needed to be allocated
  # current_account_size - size of this particular account at time of calculation
  # original_account_size - size of this particular account to begin with
  def self.set_account_asset_amount_percent(pool_size, allocation_amount, current_account_size, original_account_size)
    rtn = {}
    rtn[:amount] = ((current_account_size.to_f/pool_size.to_f) * allocation_amount)
    rtn[:percent] = ((1 - (original_account_size.to_f - rtn[:amount])/original_account_size) * 100)
    rtn
  end


  # determine weighted order to process these in
  def self.weighted_order(plan, accounts_assets)
    assets = plan.keys
    account_asset_counts = {}
    accounts_assets.each do |aa|
      assets.each do |asset|
        account_asset_counts[asset] ||= 0
        account_asset_counts[asset] += 1 if aa.include?(asset)
      end
    end
    missing = []
    full = []
    account_asset_counts.keys.each do |key|
      if account_asset_counts[key] == accounts_assets.length
        full << key
      else
        missing << key
      end
    end
    full.sort!
    missing_weighted = []
    missing.each do |asset|
      missing_weighted << {:asset => asset, :weight => plan[asset]}
    end
    missing_weighted.sort{|x,y| y[:weight] <=> x[:weight]}.map{|i| i[:asset]} + full
  end
  
  
  # plan => {1 => 70, 2 => 20, 3 => 10}
  # accounts => [{:assets => {1 => {:available => 1}, 2 => {:alternative => 3}}, :total_value => 10000}]
  def self.build_portfolios(plan, accounts, total)
    running_totals = accounts.map{|i| {:total => i[:total_value], :running_total => i[:total_value]} }
    
    total_account_assets = []
    accounts.each do |account|
      account_assets = []
      account[:assets].each_value do |value|
        account_assets << value[:available] if value.has_key?(:available)
      end
      total_account_assets << account_assets
    end
    process_order = weighted_order(plan, total_account_assets)
    process_order.each do |asset_id|
      asset_pool_size = 0
      accounts.each_with_index{|account, index| asset_pool_size += running_totals[index][:running_total] if total_account_assets[index].include?(asset_id)} # account[:assets].map{|i|i[:available]}.include?(asset_id)
      amount_required = (total * plan[asset_id] / 100.0)
      
      # if assets can be allocated in terms of the plan with no substitutions, proceed as normal
      if amount_required.as_currency <= asset_pool_size.as_currency
        accounts.each_with_index do |account, index|
          if total_account_assets[index].include?(asset_id)
            account[:percentages] ||= {}

            # normal - no substitutions
            account_asset_amounts = set_account_asset_amount_percent(asset_pool_size, (total * plan[asset_id] / 100.0), running_totals[index][:running_total], running_totals[index][:total])
            running_totals[index][:running_total] -= account_asset_amounts[:amount]
            account[:percentages][asset_id] = account_asset_amounts[:percent].as_currency
          end
        end
      else        
        amount_to_match = total * plan[asset_id] / 100.0

        # max out accounts with the asset we're short on
        accounts.each_with_index do |account, index|
          if total_account_assets[index].include?(asset_id)
            account[:percentages] ||= {}
            account[:percentages][asset_id] = (running_totals[index][:running_total] / running_totals[index][:total] * 100)
            amount_to_match -= running_totals[index][:running_total]
            running_totals[index][:running_total] -= running_totals[index][:running_total]
          end
        end

        temp_asset_pool_size = 0
        accounts.each_with_index{|account, index| temp_asset_pool_size += running_totals[index][:running_total] if accounts.map{|i| i[:assets].keys.include?(asset_id)}}

        # allocate the rest using alternatives based on the normal rules of distribution
        accounts.each_with_index do |account, index|
          if account[:assets].keys.include?(asset_id) && running_totals[index][:running_total].as_currency > 0
            account[:percentages] ||= {}
            account_asset_amounts = set_account_asset_amount_percent(temp_asset_pool_size, amount_to_match, running_totals[index][:running_total], running_totals[index][:total])
            running_totals[index][:running_total] -= account_asset_amounts[:amount]
            account[:percentages][asset_id] = account_asset_amounts[:percent].as_currency
          end
        end
      end
    end
    accounts.map{|a| a[:percentages]}
  end

end
