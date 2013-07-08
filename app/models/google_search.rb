
class GoogleSearch

  extend Garb::Model

  metrics :pageviews, :organic_searches, :percent_new_visits, :exit_rate
  dimensions :page_path, :page_title, :source

end
