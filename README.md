# capistrano 自动部署配置


## 1. 新建Rails项目

## 2. 修改 Gemfile
    
    group :development do
      gem 'capistrano'
    end
    group :assets do
      gem 'execjs'
      gem 'therubyracer', :platforms => :ruby
    end

## 3. 保证项目配置正确

    bundle
    capify .

## 3. 拷贝文件到项目中

    git clone git@github.com:fiberead/capistrano-recipes.git ~/Downloads/capistrano-recipes
    cp -r ~/Downloads/capistrano-recipes/recipes /path/to/rails/config
    cp ~/Downloads/capistrano-recipes/deploy.rb /path/to/rails/config

## 4. 修改部署变量
  
    set :server_ip,  '192.168.0.2'    #服务器地址
    set :user,       'deploy'         #服务器部署用户
    set :app_name,   'app_name'       #应用程序名称, 一般可以用git项目名称
    set :host_name,  'host.com'       #nginx配置文件域名
    set :git_server, 'git.inspiry.cn' #GIT服务器地址
    set :git_repo,   "git@#{git_server}:rails/#{app_name}.git"


## 5. 提交并部署

    git add .
    git commit -m '更新部署脚本'
    git push origin master

    cap deploy
