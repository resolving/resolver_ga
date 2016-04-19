require 'uri'

module ResolverSeo
  class SearchResult
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :company_scrape, class_name: "ResolverSeo::CompanyScrape"

    store_in database: :resolver_analytics

    field :position, type: Integer
    field :href
    field :title
    field :text

    scope :resolver, ->{ where(href: /resolver.co.uk/) }
    scope :above, ->(position){ where(:position.lt => position )  }

    def domain
      URI(href).host
    end

    def to_s
      title + '\n\n' + text
    end

  end
end
