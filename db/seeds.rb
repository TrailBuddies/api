require 'bcrypt'

User.create(
  username: 'matievisthekat',
  password: BCrypt::Password.create(ENV['PASSWORD']),
  email: ENV['EMAIL'],
  admin: true,
  verified: 'complete',
)
