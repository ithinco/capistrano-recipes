set_default(:unicorn_user)    { user }
set_default(:unicorn_pid)     { "#{shared_path}/pids/unicorn.pid" }
set_default(:unicorn_config)  { "#{shared_path}/config/unicorn.rb" }
set_default(:unicorn_workers) { 1 }

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.erb", "/tmp/unicorn_init"
    run "chmod +x /tmp/unicorn_init"
    run "#{try_sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}"
    # run "#{try_sudo} update-rc.d -f unicorn_#{application} defaults"
  end
  after "deploy:setup", "unicorn:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end