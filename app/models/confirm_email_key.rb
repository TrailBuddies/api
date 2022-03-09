class ConfirmEmailKey < ApplicationRecord
  def url
    "#{Rails.env.development ? 'http://localhost' : 'https://api.trailbuddies.club'}/confirm_email/#{self.key}"
  end
end
