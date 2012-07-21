# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
JobType.create([
	{name: 'Rakefile', script: 'rake'},
	{name: 'makefile', script: 'make'},
	{name: 'autotools', script: './configure && make'},
	{name: 'Go Tools', script: 'go test -v && go build'},
])
j = User.create(name: "jbussdieker", email: "jbussdieker@gmail.com", password: "password")
s  = User.create(name: "sammerry", email: "sam.merry@gmail.com", password: "password")

