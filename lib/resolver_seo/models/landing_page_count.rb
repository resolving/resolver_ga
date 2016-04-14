module ResolverSeo
  class LandingPageCount
    include Mongoid::Document

    SEGMENT_NAMES = {'gaid::-5' => 'Search Traffic', 'gaid::-8' => 'Referral Traffic'}

    field :segment
    field :from, type: Time
    field :to, type: Time
    field :landing_page_path
    field :entrances, type: Integer
    field :visits, type: Integer
    field :bounces, type: Integer
    field :pageviews_per_session, type: Float
    field :new_users, type: Integer
    field :avg_session_duration, type: Float 
    field :slug

    store_in database: :resolver_analytics

    belongs_to :company, class_name: 'ResolverSeo::Company'

    index({ from: 1, to: 1, company_id: 1, segment: 1, landing_page_path: 1 }, { unique: true, name: "company_landing_page_count_index" })

    scope :for_month, ->(year, month) {
       date_range = ResolverSeo::Dater.month(year, month)
       where(from: date_range.first, to: date_range.last)
    }

    scope :for_months, ->(year, month_start, months) {
       from = ResolverSeo::Dater.month(year, month_start).first
       to = ResolverSeo::Dater.month(year, month_start + (months - 1)).last
       where(:from.gte => from, :to.lte => to)
    }

    scope :organic, -> { where(segment: 'gaid::-5') }
    scope :search, -> { where(segment: 'gaid::-6') }
    scope :referral, -> { where(segment: 'gaid::-8') }
    scope :unsegmented, -> { where(segment: nil) }

    scope :company_page, -> {
      where(landing_page_path: /-complaints$/)
    }

    scope :contact_details_page, -> {
      where(landing_page_path: /contact-details$/)
    }

    def slugify
      self.slug = self.landing_page_path.match(/([^\/]+-complaints)/).captures.first
    end

    def self.group_by_company(skope)
      skope.to_a.group_by{|lpc| lpc.company_id }
    end

    def self.company_entrances(args={}, complete_results=true)
      options = LpcOptions.new(args)

      skope = ResolverSeo::LandingPageCount.send(options.segment_scope)
                                           .send(options.page_scope)
                                           .for_months(options.year, options.month_start, options.months)
      company_entrance_counts = []

      group_by_company(skope).each do |key, value|
        next if complete_results && value.size != options.months #ignore if the company doesn't have a complete set of results for this date range
        company_entrance_counts << { entrances: value.inject(0){|memo, lpc| memo += lpc.entrances },
                                    company_id: key }
      end

      company_entrance_counts.sort{|a,b| a[:entrances] <=> b[:entrances] }
    end

    class LpcOptions

      attr_accessor :options

      def initialize(args)
        self.options = args
      end

      def year
        options.fetch(:year, Date.today.year).to_i
      end

      def month_start
        options.fetch(:month_start,1).to_i
      end

      def months
        options.fetch(:months, Date.today.month).to_i
      end

      def segment_scope
        options.fetch(:segment_scope,:organic).to_sym
      end

      def page_scope 
        options.fetch(:page_scope,:company_page).to_sym
      end

    end

  end
end
