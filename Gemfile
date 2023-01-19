source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'net-smtp', '~> 0.3.1', require: false

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.4', '>= 7.0.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.6', '>= 5.6.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Allows the use of assets and stuff
gem 'sprockets-rails', '~> 3.4.2', :require => 'sprockets/railtie'

group :development, :test do
  # gem 'rswag', '~> 2.5'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1.3', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.0.0'
  gem 'rails-erd', '~> 1.6.1'
end

group :test do
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'simplecov_json_formatter', '~> 0.1.2', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2021.5', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'jwt', '~> 2.3'
gem 'rack-cors', '~> 1.1.1'

gem 'rmagick', '~> 4.2.4'
gem 'cloudinary', '~> 1.22'
gem 'httparty', '~> 0.20'

gem 'active_storage_validations', '~> 0.9', '>= 0.9.8'

gem 'dotenv-rails', '~> 2.8.1'
