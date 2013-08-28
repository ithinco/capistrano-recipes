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

## 4. 提交并部署

    git add .
    git commit -m '更新部署脚本'
    git push origin master

    cap deploy
