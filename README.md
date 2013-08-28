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
