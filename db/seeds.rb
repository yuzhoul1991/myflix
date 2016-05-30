# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["TV Commedies", "TV Dramas", "Reality TV"].each do |name|
  Fabricate(:category, name: name)
end

5.times do
  ["family_guy", "futurama", "monk", "south_park"].each do |name|
    Fabricate(:video,
              title: name,
              small_cover_url: File.join("/tmp", name + ".jpg"),
              large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
              category: Category.all.sample
              )
  end
end

3.times do
  Fabricate(:user)
end

Fabricate(:user, email: 'yuzhoul.eecs@gmail.com', password: 'password')

100.times do
  Fabricate(:review, user: User.all.sample, video: Video.all.sample)
end
