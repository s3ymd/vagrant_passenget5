# basic dependencies

sudo apt-get -y update
sudo apt-get -y autoremove
sudo apt-get -y remove --purge nano rpcbind ruby
sudo apt-get -y upgrade

sudo apt-get -y install git unzip
sudo apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
sudo apt-get -y install libsqlite3-dev nodejs apache2
sudo apt-get -y install libcurl4-openssl-dev apache2-threaded-dev libapr1-dev libaprutil1-dev

# postgresql 9.4

sudo echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-9.4 -y

# increase virtual memroy for passenger compilation
sudo dd if=/dev/zero of=/swap bs=1M count=1024
sudo mkswap /swap
sudo swapon /swap

# create user for ruby & rails

sudo adduser --disabled-password --gecos "" rails
sudo usermod -a -G sudo rails

# setup postgresql user 'rails'

sudo -u postgres createuser rails
sudo -u postgres createdb -O rails app_production

# As user 'rails':
# install ruby, rails and passengerat 
# make example application 'app' to ~rails/app/current
# get 'passenger.conf' 
# get 'secret'

su -l rails -c '/bin/bash /vagrant/setup-rails.sh'

# configure apache to work the example application

sudo cp ~rails/passenger.conf /etc/apache2/conf-available/
sudo sed -e s/XXXXXXXX/`cat ~rails/secret`/ /vagrant/rails-site.conf > /etc/apache2/sites-available/rails-site.conf
sudo rm ~rails/secret
sudo a2enconf passenger
sudo a2dissite 000-default
sudo a2ensite rails-site
sudo service apache2 restart

# reboot

sudo reboot
