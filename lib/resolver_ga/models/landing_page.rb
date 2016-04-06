module ResolverGa
  class LandingPage
    include Mongoid::Document
    include ModelFromGaResult

    before_save :slugify

    field :from, type: Time
    field :to, type: Time
    field :landing_page_path
    field :entrances, type: Integer
    field :bounces, type: Integer
    field :pageviews_per_session, type: Float
    field :new_users, type: Integer
    field :avg_session_duration, type: Time
    field :slug

    def slugify
      self.slug = self.landing_page_path.match(/([^\/]+-complaints)/).captures.first
    end
  end
end
