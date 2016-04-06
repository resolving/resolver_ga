module ResolverGa
  class Service
    include Mongoid::Document

    field :name
    field :resolver_id, type: Integer

    has_many :case_file_counts, class: ResolverGa::Count

    def self.create_from_resolver_model(service)
      model = ResolverGa::Company.find_or_create_by!(resolver_id: service.id)
      model.name = service.name
      model.save!
      model
    end
  end
end
