namespace :setup do
  task :database, roles: :app do
    # nginx config
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
    run "echo -e '\x1b[31m' Now edit the config files in #{shared_path}/config/database.yml. ;"
  end
  after "deploy:setup", "setup:database"


  task :uploads, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{deploy_to}/shared/uploads"
  end
  after "deploy:setup", "setup:uploads"

  # 项目的目录\文件依赖关系
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{current_release}/config/database.yml"
    run "ln -nfs #{shared_path}/uploads #{current_release}/public/uploads"
  end
  after "deploy:finalize_update", "setup:symlink_config"

  task :create_db do
    run "cd #{current_release}; RAILS_ENV=#{rails_env} rake db:create"
  end
  after "deploy:finalize_update", "setup:create_db"
  after "deploy:finalize_update", "deploy:migrate"
end