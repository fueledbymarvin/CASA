if Rails.env == "production"
	ENV['fb_app_id'] = "649802481704656" 
	ENV['fb_secret'] = "c59bd62b1863bf443cae32ba3306151c"
else
	ENV['fb_app_id'] = '343629322437383'
	ENV['fb_secret'] = '7e510c5b72f620481bf44d5873914161'
end

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, ENV['fb_app_id'], ENV['fb_secret'], { client_options: { :ssl => { :ca_file => '/usr/lib/ssl/certs/ca-certificates.crt' } } }
end