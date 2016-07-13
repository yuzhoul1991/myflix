Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  fullname { Faker::Name.name }
  admin { false }
  active { true }
end

Fabricator(:admin, from: :user) do
  admin { true }
end
