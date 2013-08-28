# 使用RVM部署
require "rvm/capistrano"                               # Load RVM's capistrano plugin.
require 'bundler/capistrano'

# bundler配置
set :bundle_flags,    "--deployment " # --quiet
set :bundle_without,  [:development, :test]

# 需要更新配置
###############

set :server_ip,  '192.168.0.2'    #服务器地址
set :user,       'deploy'         #服务器部署用户
set :app_name,   'app_name'       #应用程序名称, 一般可以用git项目名称
set :host_name,  'host.com'       #nginx配置文件域名
set :git_server, 'git.inspiry.cn' #GIT服务器地址
set :git_repo,   "git@#{git_server}:rails/#{app_name}.git"

###############

role :web, server_ip                         # Your HTTP server, Apache/etc
role :app, server_ip                         # This may be the same as your `Web` server
role :db, server_ip, :primary=>true

set :application, app_name

# #### 服务器环境 ####
# set :rvm_path, "/usr/local/rvm"
# set :rvm_bin_path, "/usr/local/rvm/bin"

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
load "config/recipes/base"
load "config/recipes/setup"
load "config/recipes/unicorn"
load "config/recipes/nginx"


# 开始unicorn进程数
set :unicorn_workers, 1

# 配置维护页面模板地址
set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

# 重启时开启 维护界面
before "deploy:restart", "deploy:web:disable"
after "deploy:restart", "deploy:web:enable"
after "deploy", "deploy:cleanup"

namespace :deploy do
  # 其他命令
end