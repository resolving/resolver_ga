module ResolverSeo
  class LandingPageMapper

    attr_accessor :headers, :from, :to, :segment

    def initialize(args)
      self.headers = args[:headers]
      self.from = args[:from]
      self.to = args[:to]
      self.segment = args[:segment]
    end

    def row_mapper(row)
      LandingPageRowMapper.new(self, row)
    end

    class LandingPageRowMapper

      attr_accessor :row, :mapper

      def initialize(mapper, row)
        self.mapper = mapper
        self.row = row
      end

      def data_array
        @data_array ||= _data_array
      end

      def landing_page
        @landing_page ||= data_array.find{|datum| datum.first == :landing_page_path= }.last
      end

      def visits 
        data_array.find{|datum| datum.first == :visits= }.last.to_i
      end

      def slug
        if landing_page =~ /contact-details$/
          @slug ||= landing_page.match(/([^\/]+)\/contact-details$/).captures.first
        else
          @slug ||= landing_page.match(/([^\/]+$)/).captures.first
        end
      end

      def find_or_create_landing_page_count!(company)
        puts landing_page.inspect
        company.landing_page_counts.find_or_create_by(from: mapper.from, to: mapper.to, segment: mapper.segment, landing_page_path: landing_page) do |model|
          data_array.each do |data|
            model.send(data.first, data.last)
          end
        end.save!
      end

      private

      def _data_array
        mapper.headers.collect do |header|
          data = row[mapper.headers.index(header)]
          ["#{header.name.gsub("ga:","").underscore}=".to_sym, data]
        end
      end
    end

  end
end
