module ResolverSeo
  class Company
    include Mongoid::Document

    field :resolver_id, type: Integer
    field :name
    field :slug
    field :scrape, type: Boolean

    has_many :landing_page_counts, class_name: "ResolverSeo::LandingPageCount"
    has_many :services, class_name: "ResolverSeo::Service"
    has_many :company_scrapes, class_name: 'ResolverSeo::CompanyScrape'

    store_in database: :resolver_analytics

    index({ slug: 1 }, { unique: true, name: "slug_index" })
    index({ resolver_id: 1 }, { unique: true, name: "company_resolver_id_index" })

    def self.find_or_create_from_resolver_model!(company)
      model = ResolverSeo::Company.find_or_create_by!(resolver_id: company.id)
      model.name = company.name
      model.slug = company.slug
      model.save!
      model
    end

  end
end
