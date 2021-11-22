# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Admin.create(id: 1, username: 'lukegpearson', password: '12345')
Poll.create(id: 1, title: 'test_poll1', description: 'Huehnergarth is hard to spell',
            votes_per_user: 4, votes_per_timeslot: 2, admin_id: 1, timezone: 'CDT', location: 'Seamans Center')
Poll.create(id: 2, title: 'test_poll2', description: 'Huehnergarth is hard to spell',
            votes_per_user: 4, votes_per_timeslot: 2, admin_id: 1, timezone: 'CDT', location: 'Seamans Center')
Poll.create(id: 3, title: 'test_poll3', description: 'Huehnergarth is hard to spell',
            votes_per_user: 4, votes_per_timeslot: 2, admin_id: 1, timezone: 'CDT', location: 'Seamans Center')

Timeslot.create(id:1, start: Time.new(2001,2,3,5,6,7, "+09:00"), end: Time.new(2001,2,3,6,0,0), poll_id: 1)
Timeslot.create(id:2, start: Time.new(2001,2,3,8,0,0, "+09:00"), end: Time.new(2001,2,3,11,0,0), poll_id: 1)
Timeslot.create(id:3, start: Time.new(2001,2,4,7,0,0, "+09:00"), end: Time.new(2001,2,4,8,0,0), poll_id: 1)

Block.create(timeslot_id: 1, start: '3:00', end:'3:30')
Block.create(timeslot_id: 1, start: '3:30', end:'4:00')
Block.create(timeslot_id: 1, start: '4:00', end:'4:30')
Block.create(timeslot_id: 1, start: '4:30', end:'5:00')
# Block.create(timeslot_id: 2, start: '7:00', end:'7:30')
# Block.create(timeslot_id: 2, start: '8:30', end:'8:00')
# Block.create(timeslot_id: 3, start: '12:00', end:'12:30')
# Block.create(timeslot_id: 3, start: '12:30', end:'13:00')
