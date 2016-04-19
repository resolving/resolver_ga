module ResolverSeo
  module Dater
    def self.month(year, month)
      if month < 12
        (Date.civil(year,month,1)..Date.civil(year,month + 1,1))
      else
        (Date.civil(year,month,1)..Date.civil(year + 1, month - 11, 1))
      end
    end
    
    def self.months(year, month_start, months)
      (month_start..(month_start + months - 1)).collect do |month|
        month(year,month)
      end
    end
  end
end
