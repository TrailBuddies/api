require 'bcrypt'

User.create(
  username: 'matievisthekat',
  password_digest: BCrypt::Password.create(ENV['PASSWORD']),
  email: ENV['EMAIL'],
  admin: true,
  verified: 'complete',
)
