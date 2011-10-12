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


gem 'haml'
gem 'haml-rails', :group => :development
gem 'simple_form'

group :test do
  gem 'database_cleaner'
  gem 'rails3-generators' #mainly for factory_girl & simple_form at this point
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'cucumber-rails'
  gem "pickle"
  gem 'capybara'
  gem 'guard-cucumber'
  gem "guard-rspec"
  gem "launchy"
  gem "growl" # guard asks for this gem
  gem "growl_notify"
  gem "spork", "> 0.9.0.rc" # Improve loading times during testing
  gem "guard-spork"
end