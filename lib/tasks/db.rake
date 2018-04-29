namespace :db do

  unless Rails.env.production?
    task :recreate => ['db:drop', 'db:create', 'db:migrate', 'db:seed']
  end

end
