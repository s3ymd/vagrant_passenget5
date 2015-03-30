
# ruby 2.2.1

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bash_profile
CONFIGURE_OPTS="--disable-install-rdoc" ~/.rbenv/bin/rbenv install 2.2.1
rbenv global 2.2.1

# passenger 5 "raptor"

gem install passenger -N
passenger-install-apache2-module --auto --languages ruby >> passenger.log 2>&1
passenger-install-apache2-module --snippet > passenger.conf

# rails 

gem install rails -N

# make an example application


cd /home/rails
mkdir app
cd app
rails new app -d postgresql
ln -s app current
cd current

bin/spring binstub --remove --all

rails g scaffold item name price:integer description:text

sed -i -e 's/username: app/username: rails/' config/database.yml
sed -i -e "1a \ \ root 'items#index'" config/routes.rb

rake db:migrate RAILS_ENV=production
rails runner --environment=production 'Item.create(name:"apple", price: 1000, description: "sample data")'
rake assets:precompile RAILS_ENV=production

# create 'secret' file

rake secret > ~/secret
