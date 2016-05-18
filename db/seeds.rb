# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["TV Commedies", "TV Dramas", "Reality TV"].each do |name|
  Category.create(name: name)
end

5.times do
  ["family_guy", "futurama", "monk", "south_park"].each do |name|
    Video.create( title: name,
                  description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed iaculis diam vel augue sodales, ac elementum nibh tincidunt. Suspendisse sit amet ultrices justo. Vestibulum euismod arcu porta nibh efficitur, non imperdiet augue hendrerit. Proin ornare volutpat metus. Curabitur nisl libero, eleifend quis erat et, dignissim bibendum lacus. In et aliquet purus, at laoreet libero. Sed molestie feugiat sapien in egestas. Suspendisse efficitur iaculis neque. Aenean vitae egestas libero.",
                  small_cover_url: File.join("/tmp", name + ".jpg"),
                  large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                  category: Category.all.sample
                  )
  end
end
