module ResolverSeo
  class CaseFileCount
    include Mongoid::Document

    field :from
    field :to
    field :count, type: Integer

    index({ from: 1, to: 1, service_id: 1}, { unique: true, name: "service_case_file_index" })

    store_in database: :resolver_analytics

    belongs_to :service, class_name: "ResolverSeo::Service"

    scope :for_month, ->(year, month) {
       date_range = ResolverSeo::Dater.month(year, month)
       where(from: date_range.first, to: date_range.last)
    }

    scope :for_company, ->(company) {
      self.in(service_id: company.services.pluck(:_id))
    }

  end
end
