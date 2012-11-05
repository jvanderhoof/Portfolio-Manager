require 'nokogiri'
require 'open-uri'

class Yahoo
  def self.lookup(symbol)
    url = "http://finance.yahoo.com/q/pr?s=#{symbol.upcase}+Profile"
    load_from_page(url)
  end
  
  def self.load_from_page(url)
    rtn = {:expense_ratio => '', :category => ''}
    begin
      doc = Nokogiri::HTML(open(url))
    
      cols = doc.xpath("//td[@class='yfnc_tablehead1']")
      if cols.count == 0
        cols = doc.xpath("//td[@class='yfnc_datamodlabel1'] | //td[@class='yfnc_datamoddata1']")
        cols.each_with_index do |item, i|
          if item.text.strip == 'Category:'
            rtn[:category] = cols[i+1].text
          end
          if item.text.strip == 'Annual Report Expense Ratio (net):'
            rtn[:expense_ratio] = cols[i+1].text.to_s.gsub('%','').to_f
            break
          end
        end
      else
        cols = doc.xpath("//td[@class='yfnc_tablehead1'] | //td[@class='yfnc_tabledata1'] | //td[@class='yfnc_datamodlabel1'] | //td[@class='yfnc_datamoddata1']")
        cols.each_with_index do |item, i|
          if item.text.strip == 'Category:'
            rtn[:category] = cols[i+1].text
          end
          if item.text.strip == 'Annual Report Expense Ratio (net)'
            rtn[:expense_ratio] = cols[i+1].text.to_s.gsub('%','').to_f
            break
          end
        end
      end
    rescue Exception => e
      puts "error: #{e.message}"
    end
    rtn
  end
  
end