class Calculator
  def self.xirr(value_dates, estimate)
    estimated_rate = estimate
    next_estimated_rate = 0
    iterations = 0
    
    return_type = value_dates.inject(0){|sum, i| sum += i[:value]}.round(2)
    return 0 if return_type == 0
    
    low_estimate = estimate.to_f - 0.01
    high_estimate = estimate.to_f + 0.01

    while true
      iterations += 1

      high_value = calculate_discount(value_dates, high_estimate)
      low_value = calculate_discount(value_dates, low_estimate)

      break if high_value < 0 && low_value > 0

      high_estimate += 0.01 if high_value > 0
      low_estimate -= 0.01 if low_value < 0
    end

    find_from_high_low(value_dates, high_estimate, low_estimate, 0)
  end
  
  def self.find_from_high_low(value_dates, high, low, iterations)
    high_value = calculate_discount(value_dates, high)
    low_value = calculate_discount(value_dates, low)
    if (0 - high_value) < low_value
      low = (high - low)/2 + low
    else
      high = high - (high - low)/2
    end
    
    iterations += 1
    return (high + low)/2 if iterations > 9

    find_from_high_low(value_dates, high, low, iterations)
    
  end
  
  def self.calculate_discount(value_dates, rate)
    total = 0
    value_dates.each_with_index do |value_date, i|
      days_ago = ((Time.now - value_date[:date])/60/60/24).round
      total += (value_date[:value]/((1 +rate) ** -(days_ago/365.0)))
    end
    total
  end
    
end
