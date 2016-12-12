# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

1.upto(6) do |i|
  @user = User.create full_name:"User Nr#{i}",
    email:Faker::Internet.email,
    fname:Faker::Name.first_name,
    lname:Faker::Name.last_name,
    password_digest: BCrypt::Password.create('password'),
    token: SecureRandom.base58(24)
  @user.save
  1.upto(25) do |n|
    @user.tasks.create! name:Faker::Space.constellation,
      description:Faker::Lorem.sentence,
      completed:[true, false].sample,
      deleted:[true, false].sample
  end
  @user.save
end
