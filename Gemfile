source 'http://rubygems.org'

gem 'rails', '3.1.1'
gem 'rack', '1.3.3' #1.3.4 gives warning: already initialized constant WFKV_

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'


gem 'haml'				# it replaces erb making views much cleaner
gem 'haml-rails', :group => :development
gem 'simple_form'		# Cleanest way to write a form view

gem 'haml-coderay' # provides syntax highlighting for certain programming languages

gem 'devise' # User authentication
gem 'chef', '>= 0.10.4' # opscode authentication

# once a client library gem is created, you can replace the below ones
gem 'typhoeus'
gem 'yajl-ruby'
#
gem 'reactive_resource'

group :test do
  gem 'database_cleaner'
  gem 'rails3-generators' #mainly for factory_girl & simple_form at this point
  gem 'rspec-rails'
  gem 'factory_girl_rails'	# mocking
  gem 'cucumber-rails'
  gem "pickle"			# gives you a lot of already defined cucumber steps
  gem 'capybara'
  gem 'guard' 
  gem 'growl'		# guard uses to notify
					#gem 'growl_notify' # if used, guard doesn't show the errors
  gem 'guard-cucumber'
  gem 'rb-fsevent'		# required by guard for notifications
  gem "guard-rspec"		# run rspec when a spec is saved
  gem "launchy" 		# show the web page in case of error
  gem "spork", "> 0.9.0.rc" # Improve loading times during testing
  gem "guard-spork"
  gem 'fakeweb'
  gem "vcr", "=2.0.0.beta1" #using beta2 you get: save_databag_item-databag_doesnt_exist.yml does not appear to be a valid VCR 2.0 cassette
end