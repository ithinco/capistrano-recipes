
Capistrano::Configuration.instance.load do
  namespace :shutdown do
    task :run_task, roles: :app do
      run "rm /etc/nginx/sites-enabled/#{application}"
      run "rm /etc/init.d/unicorn_#{application}"
    end
  end
end