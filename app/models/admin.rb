class Admin < ApplicationRecord

  def authenticate(password)
    self.password == password
  end

  def generate_token
    key = Rails.env.production? ? ENV["RAILS_MASTER_KEY"] : Rails.application.secrets.secret_key_base
    JWT.encode({  username: self&.username }, key, 'HS256')
  end
end
