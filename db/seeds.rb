# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create(id: 1, username: 'lukegpearson', password: '12345')
Poll.create(id: 1, title: 'test_poll', description: 'Huehnergarth is hard to spell',
            votes_per_user: 4, votes_per_timeslot: 2, admin_id: 1, timezone: 'CDT', location: 'Seamans Center')
