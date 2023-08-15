# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
 Ruby 3.1-slim
 Rails 7

* Initial Commands:

** Copy .env.example to .env
** Update the .env file if you wish
** run: docker-compose up -d
** run: docker-compose exec web bash
** within the docker container run: rails db:create
** within the docker container run: rails db:migrate
** within the docker container run: rails db:seed
 -- or --
** studies = ClinicalTrialsApi.all(days_back: 25)
** to_load = studies.map{|x| x[:id]}
** u=Util::Updater.new
** to_load.each {|id| u.update_study(id)}

* Database is postgres within the container
