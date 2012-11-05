# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


['401k/403b', 'IRA', 'Roth IRA', 'Investment Account'].each do |type|
  InvestmentAccountType.create({:name => type}) unless InvestmentAccountType.exists?({:name => type})
end

unless InvestmentAccountCompany.exists?({:name => 'Vanguard'})
  company = InvestmentAccountCompany.create({
      :name => 'Vanguard',
      :available_assets => 'VCR,VDC,VIG,VDE,EDV,VXF,VFH,VEU,VSS,VNQI,VUG,VHT,VYM,VIS,VGT,BIV,VCIT,VGIT,BIV,VCIT,VGIT,VV,BLV,VCLT,VGLT,VAW,MGC,MGK,MGV,VO,VOT,VOE,VMBS,VEA,VWO,VGK,VPL,VNQ,VOO,BSV,VCSH,VGSH,VTIP,VB,VBK,VBR,VOX,BND,VXUS,VTI,VT,VPU,VTV'
    })
end

unless InvestmentAccountCompany.exists?({:name => 'TD Ameritrade'})
  company = InvestmentAccountCompany.create({
      :name => 'TD Ameritrade',
      :available_assets => 'AOA AOK AOM AOR IJH IJR IJS IVE IVV IWB IWC IWD IWF IWN IWO IWP IWS IWV MGK VB VBK VBR VIG VO VOE VOT VTI VTV VUG VXF VYM'
    })
end
