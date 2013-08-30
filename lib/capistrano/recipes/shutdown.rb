
Capistrano::Configuration.instance.load do
  namespace :shutdown do
    task :run_task, roles: :app do
      run "#{sudo} rm /etc/nginx/sites-enabled/#{application}"
      run "#{sudo} rm /etc/init.d/unicorn_#{application}"
    end
  end
end