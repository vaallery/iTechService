web: bundle exec unicorn -c /usr/local/var/www/itechservice/current/config/unicorn.rb -E production
job: bundle exec script/delayed_job start RAILS_ENV=production
faye: bundle exec rackup private_pub.ru -s thin -E production
#faye: rackup private_pub.ru -s thin -p $PORT -e $RACK_ENV