# Tp ruby : le chat de l'année !

Ce répository est déstiné pour le tp du ruby sur la réalisation d'un chat en utilisant Heroku comme serveur, Sinatra comme templating de vue et Mongolab pour la base de donée.

## Deployer l'application en local

Vous devez posséder Ruby pour pouvoir déployer l'application. Et comme vous etes un Hypster, avoir un linux ou OSX.

```sh
$ git clone git@github.com:Narkolapin/tp-chat.git
$ cd tp-chat
$ bundle install
$ rake db:create db:migrate
$ foreman start web
```

Your app should now be running on [localhost:5000](http://localhost:5000/).

## Deploying to Heroku

```sh
$ heroku create
$ git push heroku master
$ heroku run rake db:migrate
$ heroku open
```

## Documentation

For more information about using Ruby on Heroku, see these Dev Center articles:

- [Ruby on Heroku](https://devcenter.heroku.com/categories/ruby)

