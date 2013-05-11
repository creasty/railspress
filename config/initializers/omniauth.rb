Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter,
    'UWC1Z3BYQ9GGNg1ixBiVJw',
    'ZimTPG4Cj19ETvkmPZusPKHaHN975CbIqnPrEgYXw8'

  provider :facebook,
    '423468787678045',
    '9149b132fc2dc63a2b0c582c3f68da41'

end