
Capistrano::Configuration.instance.load do
  namespace :nginx do
    desc "Install latest stable release of nginx"
    task :install, roles: :web do
      run "#{try_sudo} add-apt-repository ppa:nginx/stable"
      run "#{try_sudo} apt-get -y update"
      run "#{try_sudo} apt-get -y install nginx"
    end
    after "deploy:install", "nginx:install"

    desc "Setup nginx configuration for this application"
    task :setup, roles: :web do
      template "nginx.conf.erb", "/tmp/nginx_conf"
      run "#{try_sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
      run "#{try_sudo} rm -f /etc/nginx/sites-enabled/default"
      # restart
    end
    after "deploy:setup", "nginx:setup"
    
    %w[start stop restart].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{try_sudo} service nginx #{command}"
      end
    end
  end
end