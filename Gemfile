source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.1.5'
gem 'puma', '3.11.3'
gem 'pg', '1.0.0'

gem 'aasm', '~> 4.12'
gem 'bcrypt', '~> 3.1.1'
gem 'cancancan', '2.1.3'
gem 'acts_as_paranoid', '1.0.0.beta', :git => 'https://github.com/ActsAsParanoid/acts_as_paranoid.git', :ref => '085b5cc6d'

gem 'jbuilder', '~> 2.6'

gem 'yajl-ruby', '~> 1.3.1', require: 'yajl'



group :development, :test do
  gem 'rspec-rails', '~> 3.7.2'
  gem 'rails-controller-testing'
  gem 'rspec-expectations', '~> 3.7'
  gem 'parallel_tests', '~> 2.21.2'
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'pry-rails', '~> 0.3.2'
  gem 'json-schema'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'

  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
