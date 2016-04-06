module ResolverGa
  module ModelFromGaResult

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods

      def find_or_create_from_ga!(date_range,headers,row)
        data_array = to_data_array(headers,row)
        landing_page = data_array.find{|datum| datum.first == :landing_page_path= }.last
        find_or_create_by(landing_page_path: landing_page) do |model|
          model.from = date_range.first
          model.to = date_range.last
          to_data_array(headers, row).each do |data|
            model.send(data.first, data.last)
          end
        end.save!
      end

      private

      def to_data_array(headers,row)
        headers.collect do |header|
          data = row[headers.index(header)]
          ["#{header.name.gsub("ga:","").underscore}=".to_sym, data]
        end
      end

    end
  end
end
