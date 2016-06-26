Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  fullname { Faker::Name.name }
  admin { false }
end

Fabricator(:admin, from: :user) do
  admin { true }
end
