module ResolverSeo
  class ServiceType
    include Mongoid::Document

    field :resolver_id, type: Integer
    field :name

    has_many :services, class_name: 'ResolverSeo::Service'

    store_in database: :resolver_analytics

    index({ resolver_id: 1 }, { unique: true, name: "service_type_resolver_id_index" })

    def self.find_or_create_from_resolver_model!(service_type)
      model = ResolverSeo::ServiceType.find_or_create_by!(resolver_id: service_type.id)
      model.name = service_type.name
      model.save!
      model
    end
  end
end
