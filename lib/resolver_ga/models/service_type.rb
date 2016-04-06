module ResolverGa
  class ServiceType
    include Mongoid::Document

    field :resolver_id, type: Integer
    field :name

    has_many :services, class: ResolverGa::Service

    def self.create_from_resolver_model(service_type)
      model = ResolverGa::Company.find_or_create_by!(resolver_id: service_type.id)
      model.name = service_type.name
      model.case_file_count = service.case_files.count
      model.save!
      model
    end
  end
end
