capistrano-site5
===============

This is a simple plugin to deploy on a site5 account.

Usage
=====

1. Create a sub-domain for the rails application that you wish to deploy.
2. Site5 interface will create a sub-directory in your public_html directory.
3. Create or modify your config/deploy.rb, the minimum require is:

    `set :application, "myapp"`

    The first part of your sub-domain. ex: For myapp.example.com, you only write myapp

    `set :repository,  "your git or github url"`

    `set :user, "your username on the site5 server."`

    `server "example.com", :app, :web, :db, :primary => true`
4. If you don't want to use `/home/#{user}/rails/#{application}` for your application location, you may redefine `deploy_to`

    `#set :deploy_to, "/home/#{user}/#{application}.example.com/#{application}"`
5. `$ cap deploy:setup`

    ....
4. `$ cap deploy:check``
5. `$ cap deploy`

Example
=======

Use at your own risk.


cap deploy:setup
cap deploy:check

cap deploy


Copyright (c) 2011 Daniel Quimper, released under the MIT license