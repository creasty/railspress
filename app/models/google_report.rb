
class GoogleReport

  extend Garb::Model

  # :visits, :percentNewVisits, :organicSearches, :bounces, :entranceBounceRate
  metrics :pageviews

  # :visitorType, :source, :page_path, :page_title
  dimensions :date

end
