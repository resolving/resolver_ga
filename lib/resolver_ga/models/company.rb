module ResolverGa
  class Company
    include Mongoid::Document

    field :resolver_id, type: Integer
    field :name
    field :slug

    has_many :landing_pages
    has_many :services, class: ResolverGa::Service

    def self.create_from_resolver_model(company)
      model = ResolverGa::Company.find_or_create_by!(resolver_id: resolver_id)
      model.name = company.name
      model.slug = company.slug
      model.save!
      model
    end

  end
end
