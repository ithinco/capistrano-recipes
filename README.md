# capistrano 自动部署配置


## 1. 新建Rails项目

## 2. 修改 Gemfile
    
    group :development do
      gem 'capistrano-recipes', github: 'fiberead/capistrano-recipes'
    end

## 3. 保证项目配置正确

    bundle
    capify .

## 4. 修改deploy.rb

    # 使用RVM部署
    require "rvm/capistrano"                               # Load RVM's capistrano plugin.
    require 'bundler/capistrano'

    # bundler配置
    set :bundle_flags,    "--deployment " # --quiet
    set :bundle_without,  [:development, :test]

    # 需要更新配置
    ###############

    set :server_ip,  '192.168.0.2'    #服务器地址
    set :user,       'deploy'          #服务器部署用户
    set :app_name,   'app_name'          #应用程序名称, 一般可以用git项目名称
    set :host_name,  'host.name'     #nginx配置文件域名
    set :git_server, 'github.com' #GIT服务器地址
    set :git_repo,   "git@#{git_server}:huaican/#{app_name}.git"

    # nginx 屏蔽IE8以下的请求, 转跳到 /unsupported_browser.html
    # set :supported_old_msie, false

    ###############

    role :web, server_ip                         # Your HTTP server, Apache/etc
    role :app, server_ip                         # This may be the same as your `Web` server
    role :db, server_ip, :primary=>true

    set :application, app_name

    # #### 服务器环境 ####
    set :rvm_path, "/usr/local/rvm"
    set :rvm_bin_path, "/usr/local/rvm/bin"

    set :deploy_via, :remote_cache
    set :use_sudo, false

    set :default_run_options, {:pty => true}
    set :ssh_options, {:forward_agent => true}

    set :rails_env, 'production'
    set :keep_releases, 5   # keep only the last 5 releases

    # 版本控制
    set :scm, :git
    set :repository, git_repo
    set :branch, fetch(:branch, "master")

    if branch == 'online'
      set :deploy_to, "/home/#{user}/apps/#{application}"
    else
      set :deploy_to, "/home/#{user}/apps/#{application}_#{branch}"
    end

    # load recipes
    require 'capistrano/recipes/base'
    require 'capistrano/recipes/setup'
    require 'capistrano/recipes/unicorn'
    require 'capistrano/recipes/nginx'


    # 开始unicorn进程数
    set :unicorn_workers, 1

    # 更改维护页面模板地址
    # set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

    # # delayed_job
    # require "delayed/recipes"
    # after "deploy:stop",    "delayed_job:stop"
    # after "deploy:start",   "delayed_job:start"
    # after "deploy:restart", "delayed_job:restart"

    # 强制重启unicorn
    after "deploy:restart", "unicorn:stop"
    after "deploy:restart", "unicorn:start"

    # 重启时开启 维护界面
    before "deploy:restart", "deploy:web:disable"
    after "deploy:restart", "deploy:web:enable"
    after "deploy", "deploy:cleanup"

    namespace :deploy do
      # 其他命令
    end


## 5. 修改部署变量
  
    set :server_ip,  '192.168.0.2'    #服务器地址
    set :user,       'deploy'         #服务器部署用户
    set :app_name,   'app_name'       #应用程序名称, 一般可以用git项目名称
    set :host_name,  'host.com'       #nginx配置文件域名
    set :git_server, 'git.inspiry.cn' #GIT服务器地址
    set :git_repo,   "git@#{git_server}:rails/#{app_name}.git"


## 6. 提交并部署

    git add .
    git commit -m '更新部署脚本'
    git push origin master

    # 设置服务器相关环境, 该操作会将 config/database.yml 上传到服务器, 操作前需修改好database.yml配置, 不需要提交到版本控制
    cap deploy:setup

    cap deploy
    
    # 到线上服务器重启nginx
    sudo /etc/init.d/nginx restart


> 参考资料

> [https://github.com/capistrano/capistrano/wiki/Capistrano-Tasks](https://github.com/capistrano/capistrano/wiki/Capistrano-Tasks)

> [http://railscasts.com/episodes/335-deploying-to-a-vps](http://railscasts.com/episodes/335-deploying-to-a-vps)

> [http://railscasts.com/episodes/337-capistrano-recipes](http://railscasts.com/episodes/337-capistrano-recipes)

> [http://railscasts.com/episodes/373-zero-downtime-deployment](http://railscasts.com/episodes/373-zero-downtime-deployment)

> [https://help.github.com/articles/deploying-with-capistrano](https://help.github.com/articles/deploying-with-capistrano)
