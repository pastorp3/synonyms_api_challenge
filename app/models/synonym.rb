class Synonym < ApplicationRecord
  belongs_to :word

  enum authorization_status: { pending: 0, authorized: 1 }

  scope :authorized, -> { where(authorization_status: :authorized) }

  def authorize
    self.update!(authorization_status: 1)
  end
end
