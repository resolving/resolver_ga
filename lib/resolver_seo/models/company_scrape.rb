module ResolverSeo
  class CompanyScrape
    include Mongoid::Document
    field :term
    has_many :search_results, class_name: 'ResolverSeo::SearchResult'
    belongs_to :company
    store_in database: :resolver_analytics
  end
end
