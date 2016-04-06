module ResolverGa
  class Count
    field :from
    field :to
    field :count, type: Integer

    belongs_to :service, class: ResolverGa::Service
  end
end
