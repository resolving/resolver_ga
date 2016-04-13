module ResolverSeo
  module Dater
    def self.month(year, month)
      if month < 12
        (Date.civil(year,month,1)..Date.civil(year,month + 1,1))
      else
        (Date.civil(year,month,1)..Date.civil(year + 1,1,1))
      end
    end
  end
end
