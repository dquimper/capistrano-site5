capistrano-site5
===============

This is a simple plugin to deploy on a site5 account.

Installation
------------

Rails 2.x

`./script/plugin install git@github.com:dquimper/capistrano-site5.git`

Rails 3.x

`rails plugin install git@github.com:dquimper/capistrano-site5.git`


Usage
-----

1. Create a sub-domain for the rails application that you wish to deploy.
2. Site5 interface will create a sub-directory in your public_html directory.
3. Create or modify your config/deploy.rb, the minimum require is:

    `set :application, "myapp"`

    The first part of your sub-domain. ex: For myapp.example.com, you only write myapp

    `set :repository,  "your git or github url"`

    It is assumed that the server on which you are deploying has access to your git repository.

    `set :user, "your username on the site5 server."`

    `server "example.com", :app, :web, :db, :primary => true`
4. If you don't want to use `/home/#{user}/rails/#{application}` for your application location, you may redefine `deploy_to`

    `set :deploy_to, "/home/#{user}/#{application}.example.com/#{application}"`
5. Also, my default, Site5 links your sub-domain to `/home/#{user}/public_html/#{application}`. If you wish to modify this behavior:
    `set :public_html, "/home/#{user}/#{application}.dansrc.com/public_html"`
6. `$ cap deploy:setup`
    Capistrano will create it's regular deployment structure in your `deploy_to` directory.
    Then it will delete the directory site5 created when you created your domain and replace it with a symlink to your current public directory.
7. `$ cap deploy:check`
    Capistrano will check it's deployement structure (including your symlink to your current public directory.
8. `$ cap deploy`
    Capistrano will deploy your application and restart passenger.

Example
-------

**deploy.rb**

---
    set :application, "myapp"
    set :repository,  "git@github.com:someone/someproject.git"
    set :user, "username"
    
    server "example.com", :app, :web, :db, :primary => true
    
    # If you aren't deploying to /home/#{user}/rails/#{application} on the target
    # servers (which is the default with this capistrano-site5 plugin), you can
    # specify the actual location via the :deploy_to variable:
    #set :deploy_to, "/home/#{user}/#{application}.dansrc.com/#{application}"
    #set :public_html, "/home/#{user}/#{application}.dansrc.com/public_html"

---

Copyright (c) 2011 Daniel Quimper, released under the MIT license