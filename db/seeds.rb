# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create the initial user
User.new(username: 'ushi', password: 'ushi', email: 'ushi@example.com').save
