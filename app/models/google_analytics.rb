
class GoogleAnalytics

  class << self

    def login
      Garb::Session.api_key = ENV['GOOGLE_API_KEY']
      Garb::Session.login ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASSWORD']

      @@profile = Garb::Management::Profile.all.detect { |p|
        p.web_property_id == ENV['GOOGLE_ANALYTICS_USERAGENT']
      }
    end

    def pageview(options = {})
      GooglePageview.results @@profile, options
    end

    def search(options = {})
      GoogleSearch.results @@profile, options
    end

  end

end
