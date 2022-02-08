require 'bcrypt'

User.create(
  username: 'matievisthekat',
  password: BCrypt::Password.create(ENV['PASSWORD']),
  email: ENV['EMAIL'],
  admin: true,
  verified: 'complete',
)

User.create(
  username: 'test',
  password: BCrypt::Password.create(ENV['PASSWORD']),
  email: 'test@test.com',
  admin: false,
  verified: 'pending'
)
