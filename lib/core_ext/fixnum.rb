class Fixnum
  def as_currency
    ((self * 100).round)/100.0
  end
  
end

class Float
  def as_currency
    ((self * 100).round)/100.0
  end
  
end