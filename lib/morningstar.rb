require 'nokogiri'
require 'open-uri'

class Morningstar
  def self.lookup(symbol, type)
    case type.downcase
    when 'etf'
      url = "http://etfs.morningstar.com/quote?t=#{symbol}"
    when 'fund'
      url = "http://quote.morningstar.com/fund/f.aspx?t=#{symbol}&region=USA&culture=en-us"
    end
    load_from_page(url)    
  end
  
  def self.load_from_page(url)
    rtn = {}
    #require 'open-uri'
    #doc = Nokogiri::HTML(open(url))
    #puts doc.inspect
    #doc = open(url)
    `wget -O doc/temp.html #{url}`
    raise 'done'
    content = doc.read
    puts "length: #{content.length}"
    puts "class: #{content.class} --- "
    #puts content
    category_r = /MorningstarCategory:"([a-zA-Z ]*)"/
    puts "match? #{category_r =~ content}"
    puts "category: #{category_r.match(content)}"
    fee_r = /ExpenseRatio:"([0-9\.]*)%"/
    fee_r = /ExpenseRatio:/
    index = content.index('ExpenseRatio:', 51685)
    puts "fee index: #{index}"
    puts "fee included?: #{content.include?('ExpenseRatio:')}"
    puts "fee: #{fee_r.match(content)}"
    puts "fee: #{content.slice(index..(index + 100))}"
    #puts "category: #{category_r.match(content)[2]}"
    #rtn[:category] = category_r.match(content.to_s).last if category_r =~ content
    #puts "category #{rtn[:category]}"
    #rtn[:fee] = /ExpenseRatio:"([0-9\.]*)%"/.match(content)[1]
    #rtn
  end
end