class Word < ApplicationRecord
  has_many :synonyms

  enum authorization_status: { pending: 0, authorized: 1}

  def unauthorized?
    self.pending?
  end

  def authorize
    self.update!(authorization_status: 1)
  end
end
