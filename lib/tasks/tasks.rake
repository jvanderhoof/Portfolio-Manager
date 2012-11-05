namespace :tasks do
  
  desc "Send email reminder of investment purchases"
  task :send_purchase_lists => :environment do
    User.includes(:investment_plans).each do |user|
      user.mailable_investment_plans.each do |ip|
        if ip.next_buy_date == Date.today
          PurchaseMailer.purchase_list(ip).deliver
        end
      end
    end
  end
  
  desc "Update the current market prices for each asset"
  task :update_asset_prices => :environment do
    require 'yahoo_stock'
    assets = InvestmentAsset.where("symbol is not null and symbol <> ''").map{|a| a.symbol }
    assets.in_groups_of(200, false) do |asset_group|
      #raise asset_group.to_yaml
      quote = YahooStock::Quote.new(:stock_symbols => asset_group)
      results = quote.results(:to_hash).output
      asset_group.each_with_index do |symbol, i|
        InvestmentAsset.where(["symbol = ?", symbol]).first.update_attribute(:current_value, results[i][:last_trade_price_only].to_f.round(2))
        puts "asset: #{symbol} => $#{results[i][:last_trade_price_only].to_f.round(2)}"
      end    
    end
  end

  desc "Update dividend history for all current assets"
  task :set_dividend_history => :environment do
    require 'yahoo_stock'
    InvestmentAsset.all.each do |asset|
      begin 
        history = YahooStock::History.new(:stock_symbol => asset.symbol, :start_date => Date.today - 30, :end_date => Date.today - 1, :type => :dividend)
        results = history.results(:to_hash).output
        results.each do |row|
          ah = AssetHistory.where(['day = ? and investment_asset_id = ?', Date.parse(row[:date]), asset.id]).first
          ah.update_attribute(:dividend, row[:dividends])
        end
      rescue Exception => e
        puts "no historical information for: #{asset.symbol}"
      end
    end    
  end

  desc "Update historical prices for all current assets"
  task :set_historical_data => :environment do
    require 'yahoo_stock'
    #years_ago = 30
    InvestmentAsset.all.each do |asset|
      last_update = AssetHistory.where(["investment_asset_id = ?", asset.id]).order('day desc').first
      unless last_update.blank?
        date = last_update.day
      else
        date = Date.today - years_ago * 365
      end
      begin 
        history = YahooStock::History.new(:stock_symbol => asset.symbol, :start_date => date, :end_date => Date.today - 1)
        results = history.results(:to_hash).output
        results.each do |row|
          AssetHistory.create({
              :investment_asset_id => asset.id,
              :open => row[:open],
              :close => row[:close],
              :high => row[:high],
              :low => row[:low],
              :day => Date.parse(row[:date])            
            }) unless AssetHistory.exists?({:investment_asset_id => asset.id, :day => Date.parse(row[:date])})
        end
      rescue Exception => e
        puts "no historical information for: #{asset.symbol}"
      end
    end
  end
  
  desc "Set portfolio returns"
  task :set_portfolio_returns => :environment do
    Portfolio.all.each do |portfolio|
      puts portfolio.id
      rtn = portfolio.historical(1)
      next unless rtn[:years] == 1
      portfolio.update_attribute(:one_year_return, rtn[:compound_annual_growth])
      
      rtn = portfolio.historical(3)
      next unless rtn[:years] == 3
      portfolio.update_attribute(:three_year_return, rtn[:compound_annual_growth])
      
      rtn = portfolio.historical(5)
      next unless rtn[:years] == 5
      portfolio.update_attribute(:five_year_return, rtn[:compound_annual_growth])
      
      rtn = portfolio.historical(10)
      next unless rtn[:years] == 10
      portfolio.update_attribute(:ten_year_return, rtn[:compound_annual_growth])
      
      rtn = portfolio.historical(20)
      next unless rtn[:years] == 20
      portfolio.update_attribute(:twenty_year_return, rtn[:compound_annual_growth])
    end
  end
  
  task :historical => :environment do
    puts Portfolio.find(24).historical#(20,'monthly',500,0,true)
    #ip = InvestmentPlan.find(1)
    #ip.historical(300, 'monthly', 10)
  end
  
  task :monthly => :environment do
    monthly_investment = 300.0
    total_invested = 0
    banked_amount = 0
    total_shares = 0
    months_ago = 120
    symbol = 'SPY'
    trading_fee = 0#7.00
    
    asset = InvestmentAsset.where(["symbol = ?", symbol])
    ah = AssetHistory.where(["asset_id = ?", asset]).order('day asc').first
    months = ((Date.today - ah.day)/30).round
    months_ago = months if months < months_ago
    puts "months ago: #{months_ago}"
    
    (0..months_ago).each do |i|
      i = AssetHistory.where(["asset_id = ? and day >= ?", asset, (months_ago - i).months.ago.to_date]).order('day asc').first
      next if i.blank?
      price = ((i.open + i.close)/2).round(2)
      shares_to_purchase = ((monthly_investment + banked_amount)/price).to_i
      total_shares += shares_to_purchase
      cost = price * shares_to_purchase
      total_invested += cost
      total_invested += trading_fee
      banked_amount = (monthly_investment + banked_amount - cost).round(2)
    end
    
    i = AssetHistory.where(["asset_id = ?", asset]).order('day desc').first
    price = ((i.open + i.close)/2).round(2)
    puts "price: #{price}"
    puts "total invested: #{total_invested}, shares: #{total_shares}, avg share price: #{(total_invested/total_shares).round(2)}"
    total_value = ((i.open + i.close)/2).round(2) * total_shares
    puts "total_value = #{total_value}"
    puts "return: #{((total_invested/total_value)**((1/(months_ago/12))-1)).round(2)}"
    
    h = AssetHistory.where(["asset_id = ? and day >= ?", asset, months_ago.months.ago.to_date]).order('day asc').first
    old_price = ((h.open + h.close)/2).round(2)
    shares = (total_invested/old_price).to_i
    puts "shares: #{shares}"
    total_value = shares * old_price
    current_value = shares * price
    puts "return: #{((total_value/current_value)**((1/(months_ago/12))-1)).round(2)}"
  end
  
  
  
  task :test_xirr => :environment do
    Portfolio.find(24).historical(3).to_yaml
  end
  
  task :test => :environment do
    require 'calculator'
    pa = PortfolioAsset.find(141)
    pa.calculate_return(BuyListAsset.where("id in (?)", [24,28]))
  end
  
  
  
  task :test_10_day => :environment do
    pool_size = 1_000
    trade_fee = 4.95
    years_ago = 1
    symbols = ['MMM','ABT','ANF','ADBE','AMD','AES','AET','AFL','A','APD','AKAM','AKS','AA','AYE','ATI','AGN','ALL','ALTR','MO','AMZN','AEE','AEP','AXP','AMT','AMP','ABC','AMGN','APC','ADI','APA','AIV','APOL','AAPL','AMAT','ADM','ASH','AIZ','T','ADSK','ADP','AN','AZO','AVB','AVY','AVP','BHI','BLL','BAC','BK','BCR','BAX','BBT','BDX','BBBY','BMS','BBY','BIG','BIIB','HRB','BMC','BA','BXP','BSX','BMY','BRCM','BFb','CHRW','CA','COG','CAM','CPB','COF','CAH','CCL','CAT','CBG','CBS','CELG','CNP','CTL','CF','SCHW','CHK','CVX','CB','CIEN','CI','CINF','CTAS','CSCO','C','CTXS','CLX','CME','CMS','COH','KO','CCE','CTSH','CL','CMCSA','CMA','CSC','CPWR','CAG','COP','CNX','ED','STZ','CEG','CVG','CBE','GLW','COST','CVH','CSX','CMI','CVS','DHI','DHR','DRI','DVA','DF','DE','DELL','DNR','XRAY','DVN','DV','DO','DTV','DFS','D','RRD','DOV','DOW','DPS','DTE','DD','DUK','DNB','DYN','ETFC','EMN','EK','ETN','EBAY','ECL','EIX','EP','EA','EMC','EMR','ESV','ETR','EOG','EQt','EFX','EQR','EL','EXC','EXPE','EXPD','ESRX','XOM','FDO','FAST','FII','FDX','FIS','FITB','FHN','FE','FISV','FLIR','FLS','FLR','FTI','F','FRX','BEN','FCX','FTR','GME','GCI','GPS','GD','GE','GIS','GPC','GNW','GILD','GS','GR','GT','GOOG','GWW','HAL','HOG','HAR','HRS','HIG','HAS','HCP','HCN','HNZ','HES','HPQ','HD','HON','HRL','HSP','HST','HCBK','HUM','HBAN','ITW','TEG','INTC','ICE','IBM','IFF','IGT','IP','IPG','INTU','ISRG','IVZ','IRM','ITT','JBL','JEC','JNS','JDSU','JNJ','JCI','JPM','JNPR','KBH','K','KEY','KMB','KIM','KLAC','KSS','KFT','KR','LLL','LH','LM','LEG','LEN','LUK','LXK','LIFE','LLY','LTD','LNC','LLTC','LMT','L','LO','LOW','LSI','MTB','M','MTW','MRO','MAR','MMC','MI','MAS','MEE','MA','MAT','MBI','MFE','MKC','MCD','MHP','MCK','MWV','MHS','MDT','WFR','MRK','MDP','MET','PCS','MCHP','MU','MSFT','MIL','MOLX','TAP','MON','MWW','MCO','MS','MOT','MUR','MYL','NBR','NDAQ','NOV','NTAP','NYT','NWL','NEM','NWSA','GAS','NKE','NI','NBL','JWN','NSC','NTRS','NOC','NU','NOVL','NVLS','NUE','NVDA','NYX','ORLY','OXY','ODP','OMC','ORCL','OI','PCAR','PTV','PLL','PH','PDCO','PAYX','BTU','JCP','PBCT','POM','PEP','PKI','PFE','PCG','PM','PNW','PXD','PBI','PCL','PNC','RL','PPG','PPL','PX','PCP','PFG','PG','PGN','PGR','PLD','PRU','PEG','PSA','PHM','QLGC','PWR','QCOM','DGX','STR','RSH','RRC','RTN','RHT','RF','RSG','RAI','RHI','ROK','COL','RDC','R','SWY','CRM','SNDK','SLE','SCG','SLB','SNI','SEE','SHLD','SRE','SHW','SIAL','SPG','SLM','SJM','SNA','SO','LUV','SWN','SE','S','STJ','SWK','SPLS','SBUX','HOT','STT','SRCL','SYK','SUN','STI','SVU','SYMC','SYY','TROW','TGT','TE','TLAB','THC','TDC','TER','TSO','TXN','TXT','HSY','TRV','TMO','TIF','TWX','TWC','TIE','TJX','TMK','TSS','TSN','USB','UNP','UNH','UPS','X','UTX','UNM','VFC','VLO','VAR','VTR','VRSN','VZ','VIAb','VNO','VMC','WMT','WAG','DIS','WPO','WM','WAT','WPI','WLP','WFC','WDC','WU','WY','WHR','WFM','WMB','WIN','WEC','WYN','WYNN','XEL','XRX','XLNX','XL','YHOO','YUM','ZMH','ZION']
    assets = InvestmentAsset.where("symbol in (?)", symbols).inject({}){|result, a| result[a.symbol] = a.id; result}
    seed_asset = nil
    assets.values.each do |ia|
      if AssetHistory.where(["day < ? and investment_asset_id = ?", years_ago.years.ago - 2.weeks, ia]).count > 1
        seed_asset = AssetHistory.where(["day > ? and investment_asset_id = ?", years_ago.years.ago - 2.weeks, ia]).order('day asc')
        break
      end
    end
    history = {}
    count = 0
    seed_asset.each_with_index do |asset, i|
      count += 1
      AssetHistory.where(["investment_asset_id in (?) and day = ?", assets.values, asset.day]).each do |ah|
        history[ah.investment_asset_id] ||= {}
        history[ah.investment_asset_id][i] = ah.close
      end
    end
    
    investment_amounts = {0 => pool_size, 1 => pool_size, 2 => pool_size, 3 => pool_size, 4 => pool_size}
    cost = 0
    value = 0
    (10..(count - 5)).each do |i|
      max_change = 0
      max_change_asset = nil
      history.keys.each do |key|
        possible_buy = true
        (1..10).each do |days_ago|
          next if history[key][i].blank? || history[key][i-days_ago].blank?
          if history[key][i] > history[key][i-days_ago]
            possible_buy = false 
            break
          end
        end
        next if history[key][i+5].blank?
        if possible_buy
          shares = (100 / history[key][i]).floor
          cost += shares * history[key][i] + trade_fee
          value += shares * history[key][i+5]
        end
      end
    end
    puts "change: #{((value-cost)/cost)*100.round(2)}"
  end
  
  task :process_log => :environment do
    first = true
    file = []
    File.open('log/sp_output_monthly.log', 'r') do |dirty|
      while line = dirty.gets
        if first
          first = false
          next
        end
        row = line.gsub("\n",'')
        row_cols = row.gsub(' =>',',').gsub('total value', 'total_value').split(', ')
        row_hsh = {}
        row_cols.each do |c|
          col_parts = c.gsub('%','').gsub('$','').split(': ')
          row_hsh[col_parts[0].strip.to_sym] = col_parts[1].to_f
        end
        file << row_hsh if row_hsh[:years] >= 8 && row_hsh[:years] <= 20
      end
      file.sort!{|x,y| y[:return] <=> x[:return]}
      
      specs = {}
      keys = [:months_passed, :months_future, :pool_size]
      keys.each do |key|
        specs[key] = {}
      end
      puts file.length
      size = 1000
      (0..size).each do |i|
        row = file[i]
        #raise row.inspect
        keys.each do |key|
          specs[key][row[key]] ||= 0
          specs[key][row[key]] += 1 * (row[:return]/1000)
        end
      end
      keys.each do |key|
        puts "#{key}:"
        specs[key].keys.sort.each{|k| puts "  #{k.to_i} => #{specs[key][k].round(3)}"}
      end
      
=begin
      optimal: pool size around 4 or 5
      months future: around 5
      months past: 3 - 7
      
=end
        
    end
  end
  
  task :sp => :environment do
    require 'logger'
    log = Logger.new('log/output.log')
    years_range = [1,3,5,8,10,15,20] #[8,10,15,20] #
    months_passed_range = (1..12)
    months_future_range = (1..12)
    pool_sizes_range = (1..10)
    
    historical_prices = {}
    symbols = ['MMM','ABT','ANF','ADBE','AMD','AES','AET','AFL','A','APD','AKAM','AKS','AA','AYE','ATI','AGN','ALL','ALTR','MO','AMZN','AEE','AEP','AXP','AMT','AMP','ABC','AMGN','APC','ADI','APA','AIV','APOL','AAPL','AMAT','ADM','ASH','AIZ','T','ADSK','ADP','AN','AZO','AVB','AVY','AVP','BHI','BLL','BAC','BK','BCR','BAX','BBT','BDX','BBBY','BMS','BBY','BIG','BIIB','HRB','BMC','BA','BXP','BSX','BMY','BRCM','BFb','CHRW','CA','COG','CAM','CPB','COF','CAH','CCL','CAT','CBG','CBS','CELG','CNP','CTL','CEPH','CF','SCHW','CHK','CVX','CB','CIEN','CI','CINF','CTAS','CSCO','C','CTXS','CLX','CME','CMS','COH','KO','CCE','CTSH','CL','CMCSA','CMA','CSC','CPWR','CAG','COP','CNX','ED','STZ','CEG','CVG','CBE','GLW','COST','CVH','CSX','CMI','CVS','DHI','DHR','DRI','DVA','DF','DE','DELL','DNR','XRAY','DVN','DV','DO','DTV','DFS','D','RRD','DOV','DOW','DPS','DTE','DD','DUK','DNB','DYN','ETFC','EMN','EK','ETN','EBAY','ECL','EIX','EP','ERTS','EMC','EMR','ESV','ETR','EOG','EQt','EFX','EQR','EL','EXC','EXPE','EXPD','ESRX','XOM','FDO','FAST','FII','FDX','FIS','FITB','FHN','FE','FISV','FLIR','FLS','FLR','FTI','F','FRX','BEN','FCX','FTR','GME','GCI','GPS','GD','GE','GIS','GPC','GNW','GILD','GS','GR','GT','GOOG','GWW','HAL','HOG','HAR','HRS','HIG','HAS','HCP','HCN','HNZ','HES','HPQ','HD','HON','HRL','HSP','HST','HCBK','HUM','HBAN','ITW','TEG','INTC','ICE','IBM','IFF','IGT','IP','IPG','INTU','ISRG','IVZ','IRM','ITT','JBL','JEC','JNS','JDSU','JNJ','JCI','JPM','JNPR','KBH','K','KEY','KMB','KIM','KLAC','KSS','KFT','KR','LLL','LH','LM','LEG','LEN','LUK','LXK','LIFE','LLY','LTD','LNC','LLTC','LMT','L','LO','LOW','LSI','MTB','M','MTW','MRO','MAR','MMC','MI','MAS','MEE','MA','MAT','MBI','MFE','MKC','MCD','MHP','MCK','MWV','MHS','MDT','WFR','MRK','MDP','MET','PCS','MCHP','MU','MSFT','MIL','MOLX','TAP','MON','MWW','MCO','MS','MOT','MUR','MYL','NBR','NDAQ','NOV','NTAP','NYT','NWL','NEM','NWSA','GAS','NKE','NI','NBL','JWN','NSC','NTRS','NOC','NU','NOVL','NVLS','NUE','NVDA','NYX','ORLY','OXY','ODP','OMC','ORCL','OI','PCAR','PTV','PLL','PH','PDCO','PAYX','BTU','JCP','PBCT','POM','PEP','PKI','PFE','PCG','PM','PNW','PXD','PBI','PCL','PNC','RL','PPG','PPL','PX','PCP','PFG','PG','PGN','PGR','PLD','PRU','PEG','PSA','PHM','QLGC','PWR','QCOM','DGX','STR','RSH','RRC','RTN','RHT','RF','RSG','RAI','RHI','ROK','COL','RDC','R','SWY','CRM','SNDK','SLE','SCG','SLB','SNI','SEE','SHLD','SRE','SHW','SIAL','SPG','SLM','SJM','SNA','SO','LUV','SWN','SE','S','STJ','SWK','SPLS','SBUX','HOT','STT','SRCL','SYK','SUN','STI','SVU','SYMC','SYY','TROW','TGT','TE','TLAB','THC','TDC','TER','TSO','TXN','TXT','HSY','TRV','TMO','TIF','TWX','TWC','TIE','TJX','TMK','TSS','TSN','USB','UNP','UNH','UPS','X','UTX','UNM','VFC','VLO','VAR','VTR','VRSN','VZ','VIAb','VNO','VMC','WMT','WAG','DIS','WPO','WM','WAT','WPI','WLP','WFC','WDC','WU','WY','WHR','WFMI','WMB','WIN','WEC','WYN','WYNN','XEL','XRX','XLNX','XL','YHOO','YUM','ZMH','ZION']
    assets = InvestmentAsset.where("symbol in (?)", symbols).inject({}){|result, a| result[a.symbol] = a.id; result}
    asset_translations = assets.invert
    
    months = 24 + years_range.last * 12

    seed_asset = 0
    assets.values.each do |ia|
      if AssetHistory.where(["day < ? and investment_asset_id = ?", (years_range.last+1).years.ago - 2.weeks, ia]).count > 1
        seed_asset = ia
        break
      end
    end
    
    (0..months).each do |m|
      date = m.months.ago(2.weeks.ago)      
      ah = AssetHistory.where(["investment_asset_id = ? and day > ?", seed_asset, date]).order('day asc').first
      AssetHistory.where(["investment_asset_id in (?) and day = ?", assets.values, ah.day]).each do |h|
        historical_prices[h.investment_asset_id] ||= {}
        historical_prices[h.investment_asset_id][m] = {:price => ((h.open + h.close)/2).round(2), :past => {}, :day => h.day} unless h.open.blank? || h.close.blank?
      end
    end

    historical_prices.keys.each_with_index do |key, i|
      start_time = Time.now
      historical_prices[key].keys.each do |month|
        (1..12).each do |i|
          next if historical_prices[key].blank? || historical_prices[key][month].blank? || historical_prices[key][month+i].blank?
          historical_prices[key][month][:past][i] = (historical_prices[key][month][:price] - historical_prices[key][month+i][:price])/historical_prices[key][month+i][:price]
        end
      end
    end
    
    years_range.each do |years|
      months_passed_range.each do |months_passed|
        months_future_range.each do |months_future|
          pool_sizes_range.each do |pool_size|
            puts "#{years}, #{months_passed}, #{months_future}, #{pool_size}"
            months_ago = years * 12 + months_future + 1
            #puts "months_ago: #{months_ago}"
            initial_investment = 2_000
            #money = 1.0 * initial_investment
            trade_fee = 4.95 #7.99
            trading_cycles = {}
            while months_ago >= months_future + 1
              trading_cycles[months_ago%months_future] ||= 1.0 * initial_investment
              stocks = []
              asset_symbol = ''
              asset_loss = 0
              stocks = []
              historical_prices.keys.each do |key|                
                if historical_prices[key].present? && historical_prices[key][months_ago].present? && historical_prices[key][months_ago][:past].present?
                  unless historical_prices[key][months_ago][:past][months_passed].blank? || historical_prices[key][months_ago-months_future].blank?
                    stocks << {:change => historical_prices[key][months_ago][:past][months_passed], :price => historical_prices[key][months_ago][:price], :investment_asset_id => key} 
                  end
                end
              end
              stocks.sort!{|x,y| y[:change] <=> x[:change]}
              buy_stocks = []
              unless stocks.blank?
                pool_size.times{|p| buy_stocks << stocks.pop} 
                unless buy_stocks.length == 0
                  trading_cycles[months_ago%months_future] -= trade_fee * pool_size
                  buy_stocks.each do |buy_stock|
                    unless historical_prices[buy_stock[:investment_asset_id]][months_ago-months_future].blank?
                      pool_size_money = (trading_cycles[months_ago%months_future].to_f/pool_size)
                      stock_count = (pool_size_money/buy_stock[:price]).floor
                      #puts "buy: #{stock_count} of #{asset_translations[buy_stock[:investment_asset_id]]} (#{buy_stock[:investment_asset_id]}) for $#{buy_stock[:price].round(2)}"
                      trading_cycles[months_ago%months_future] -= stock_count * buy_stock[:price]
                      trading_cycles[months_ago%months_future] += stock_count * historical_prices[buy_stock[:investment_asset_id]][months_ago-months_future][:price]
                      #puts "sell: #{stock_count} of #{asset_translations[buy_stock[:investment_asset_id]]} for $#{historical_prices[buy_stock[:investment_asset_id]][months_ago-months_future][:price].round(2)}  (#{months_ago-months_future})"
                    end
                  end
                end
              end
              #months_ago -= months_future
              months_ago -= 1
            end
            money = trading_cycles.keys.inject(0){|results, i| results += trading_cycles[i]}
            total_initial_investment = initial_investment * months_future
            calc_return = (((money/total_initial_investment - 1)/years) * 100).round(2)
            puts "value: $#{money.round(2)}, return #{calc_return}%"
            log.info "years: #{years}, months_passed: #{months_passed}, months_future: #{months_future}, pool_size: #{pool_size} => return: #{calc_return}%, total value: $#{money.round(2)}"
          end
        end
      end
    end
  end
  
  task :dow => :environment do
    File.open('doc/dow.txt', 'r') do |dirty|
      while line = dirty.gets
        row = line.gsub("\n",'').split("\t")
        puts row.inspect
      end
    end
  end
  
  
  task :s_p => :environment do
    File.open('doc/s_p.txt', 'r') do |dirty|
      while line = dirty.gets
        row = line.gsub("\n",'').split("\t")
        symbol = (row.length == 3) ? row[2] : row[3]
        symbol.gsub!('.','')
        ia = InvestmentAsset.where(["symbol = ?", symbol]).first
        if ia.blank?
          begin
            ia = InvestmentAsset.create({:symbol => symbol, :name => row[0], :morningstar_classification => row[1]})
            puts "added: #{symbol}"
          rescue
            puts "#{symbol} - yahoo threw up"
          end
        else
          ia.update_attributes({:name => row[0], :morningstar_classification => row[1]})
        end
        unless ia.blank?
          ia.reload
          puts ia.symbol if ia.asset_histories.length < 10
        end
      end
    end
  end
  
  task :initial_import => :environment do
    
    funds = %w{MRAXX NECZX OSICX BPRCX BCCPX MCLOX BCMPX TIBCX BCGPX MCDVX MEICX BCAPX NYVCX TVCFX JACCX BMCCX AMGCX MCSWX MRICX JIGCX THGCX GLLCX MCEGX TEDSX MCPCX GEGCX MCLTX SHSCX MCGRX}
    funds.each{|f| InvestmentAsset.find_or_create_by_symbol(:symbol => f) }
    
    funds = %w{VCR VDC VIG VDE EDV VXF VFH VEU VSS VNQI VUG VHT VYM VIS VGT BIV VCIT VGIT VV BLV VCLT VGLT VAW MGC MGK MGV VO VOT VOE VMBS VEA VWO VGK VPL VNQ VOO BSV  VCSH VGSH VB VBK VBR VOX BND VXUS VTI VT VPU VTV}
    funds.each{|f| InvestmentAsset.find_or_create_by_symbol(:symbol => f) }
    
  end
  
  task :test_yahoo => :environment do
    require 'yahoo'
    funds = %w{MRAXX NECZX OSICX BPRCX BCCPX MCLOX BCMPX TIBCX BCGPX MCDVX MEICX BCAPX NYVCX TVCFX JACCX BMCCX AMGCX MCSWX MRICX JIGCX THGCX GLLCX MCEGX TEDSX MCPCX GEGCX MCLTX SHSCX MCGRX}
    funds = %w{VCR VDC VIG VDE EDV VXF VFH VEU VSS VNQI VUG VHT VYM VIS VGT BIV VCIT VGIT VV BLV VCLT VGLT VAW MGC MGK MGV VO VOT VOE VMBS VEA VWO VGK VPL VNQ VOO BSV  VCSH VGSH VB VBK VBR VOX BND VXUS VTI VT VPU VTV}
    funds.each do |fund|
      rtn = Yahoo.lookup(fund)
      
      #InvestmentAssetCategory.create({:name => rtn[:category], :key => rtn[:category].downcase.strip}) unless rtn[:category].blank? || InvestmentAssetCategory.exists?({:key => rtn[:category].downcase.strip})
      #investment_asset = InvestmentAsset.find_or_create_by_symbol(fund.upcase)
      #investment_asset.update_attributes({})
      puts "#{fund} => #{rtn.inspect}"
    end
  end
  
  task :etfdb => :environment do
    require 'etfdb'
    Etfdb.lookup('')
  end

  task :test_morningstar => :environment do
    require 'morningstar'
    rtn = Morningstar.lookup('JNK', 'etf')
    #puts rtn.to_yaml
  end

end
