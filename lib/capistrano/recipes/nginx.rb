
Capistrano::Configuration.instance.load do
  set_default(:supported_old_msie) { true }

  namespace :nginx do
    desc "Install latest stable release of nginx"
    task :install, roles: :web do
      run "#{sudo} add-apt-repository ppa:nginx/stable"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nginx"
    end
    after "deploy:install", "nginx:install"

    desc "Setup nginx configuration for this application"
    task :setup, roles: :web do
      template "nginx.conf.erb", "/tmp/nginx_conf"
      run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
      run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
      # restart
    end
    after "deploy:setup", "nginx:setup"
    
    %w[start stop restart].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} /etc/init.d/nginx #{command}"
      end
    end
  end
end