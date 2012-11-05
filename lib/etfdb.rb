class Etfdb
  def self.lookup(symbol)
    #url = "http://finance.yahoo.com/q/pr?s=#{symbol.upcase}+Profile"
    url = "http://etfdb.com/type/size/large-cap/expenses/"
    load_from_page(url)
  end
    
  def self.load_from_page(url)
    #doc = Nokogiri::HTML(open(url))
    doc = Nokogiri::HTML(File.open('doc/etfdb.html'))
    
    doc.xpath("//tr").each_with_index do |row, index|      
      next if index == 0
      cols = row.text.gsub("\t",'').split("\n")
      InvestmentAsset.create({:symbol => cols[0], :name => cols[1], :expense_ratio => cols[4].gsub('%','').to_f}) unless InvestmentAsset.exists?({:symbol => cols[0]})
    end
    
    #puts rows.count.to_s
  end
end