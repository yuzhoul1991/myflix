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
              small_cover: File.open(File.join(Rails.root, "public/tmp", name + ".jpg")),
              large_cover: File.open(File.join(Rails.root, "public/tmp/placeholder.png")),
              category: Category.all.sample
              )
  end
end

3.times do
  Fabricate(:user)
end

Fabricate(:admin, email: 'yuzhoul.eecs@gmail.com', password: 'password', fullname: 'Yuzhou Liu')

100.times do
  Fabricate(:review, user: User.all.sample, video: Video.all.sample)
end

User.all.each do |user|
  (1..2).to_a.each do |position|
    Fabricate(:queue_item, position: position, user: user, video: Video.all.sample)
  end
end
