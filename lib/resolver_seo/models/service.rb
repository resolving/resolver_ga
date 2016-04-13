module ResolverSeo
  class Service
    include Mongoid::Document

    field :name
    field :resolver_id, type: Integer

    belongs_to :company, class_name: 'ResolverSeo::Company'
    has_many :case_file_counts, class_name: "ResolverSeo::CaseFileCount"
    belongs_to :service_type, class_name: "ResolverSeo::ServiceType"

    store_in database: :resolver_analytics

    index({ service_type_id: 1 }, { name: "service_type_index" })
    index({ company_id: 1 }, { name: "company_index" })
    index({ resolver_id: 1 }, { unique: true, name: "service_resolver_id_index" })

    def self.find_or_create_from_resolver_model!(company, service)
      model = find_or_create_by(resolver_id: service.id)
      model.name = service.name
      model.company = company
      model.save!
      model
    end
  end
end
