module ResolverSeo
  class SearchResult
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :company_scrape, class_name: "ResolverSeo::CompanyScrape"

    field :position, type: Integer
    field :href
    field :title
    field :text

  end
end
