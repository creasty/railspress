Rails.application.config.middleware.use Browsernizer::Router do |config|
  config.supported 'Internet Explorer', '10'
  config.supported 'Firefox', '17'
  config.supported 'Opera', '11.1'
  config.supported 'Chrome', '26'

  config.location  '/unsupported_browser.html'
  config.exclude   %r{^/assets}
end
