
class GoogleAnalytics

  class << self

    def login
      Garb::Session.api_key = ENV['GOOGLE_API_KEY']
      Garb::Session.login ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASSWORD']
    end

    def pageview(url = '/', options = {})
      options[:filters] = { 'page_path.eql' => url }

      profile = Garb::Management::Profile.all.detect { |p|
        p.web_property_id == ENV['GOOGLE_ANALYTICS_USERAGENT']
      }

      GoogleReport.results profile, options
    end

  end

end
