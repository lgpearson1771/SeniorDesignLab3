# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Invitee.create(email: 'bob@gmail.com', votes_left: 2, poll_id: 1)
Invitee.create(email: 'tom@gmail.com', votes_left: 2, poll_id: 1)
Invitee.create(email: 'phil@gmail.com', votes_left: 2, poll_id: 1)


Admin.create(id: 1, username: 'SirOhmbre', password: '12345')
Poll.create(id: 1, title: 'Lab3 Checkoff', description: 'Huehnergarth is hard to spell',
            votes_per_user: 4, votes_per_timeslot: 2, admin_id: 1, timezone: 'CDT', location: 'Seamans Center')
Poll.create(id: 2, title: 'test_poll2', description: 'Huehnergarth is hard to spell',
            votes_per_user: 4, votes_per_timeslot: 2, admin_id: 1, timezone: 'CDT', location: 'Seamans Center')
Poll.create(id: 3, title: 'test_poll3', description: 'Huehnergarth is hard to spell',
            votes_per_user: 4, votes_per_timeslot: 2, admin_id: 1, timezone: 'CDT', location: 'Seamans Center')
Timeslot.create(id:1, start: '03:00', end: '05:00', poll_id: 1, day: Time.parse('2021-11-21'))
Timeslot.create(id:2, start: '07:00', end: '08:00', poll_id: 1, day: Time.parse('2021-11-21'))
Timeslot.create(id:3, start: '12:00', end: '13:00', poll_id: 1, day: Time.parse('2021-11-22'))
Timeslot.create(id:4, start: '04:30', end: '07:30', poll_id: 1, day: Time.parse('2021-11-25'))
Timeslot.create(id:5, start: '12:00', end: '14:00', poll_id: 1, day: Time.parse('2021-11-28'))

Block.create(timeslot_id: 1, start: '03:00', end:'03:30')
Block.create(timeslot_id: 1, start: '03:30', end:'04:00')
Block.create(timeslot_id: 1, start: '04:00', end:'04:30')
Block.create(timeslot_id: 1, start: '04:30', end:'05:00')
Block.create(timeslot_id: 2, start: '07:00', end:'07:30')
Block.create(timeslot_id: 2, start: '07:30', end:'08:00')
Block.create(timeslot_id: 3, start: '12:00', end:'12:30')
Block.create(timeslot_id: 3, start: '12:30', end:'13:00')

Block.create(timeslot_id: 4, start: '04:30', end:'05:15')
Block.create(timeslot_id: 4, start: '05:15', end:'06:00')
Block.create(timeslot_id: 4, start: '06:00', end:'06:45')
Block.create(timeslot_id: 4, start: '06:45', end:'07:30')

Block.create(timeslot_id: 5, start: '12:00', end:'14:00')

Invitee.create(email: 'tessa-schmidts@uiowa.edu', votes_left: 4, poll_id: 1)
Invitee.create(email: 'nick-gorman@uiowa.edu', votes_left: 4, poll_id: 1)
