module Mutations
  class AdminLogin < BaseMutation
    argument :user, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(user:, password:)
      admin = Admin.find_by(username: user)

      if admin&.authenticate(password)
        token = generate_token(admin)
        { token: token, errors: [] }
      else
        { token: nil, errors: ['Invalid username or password'] }
      end
    end

    private

    def generate_token(admin)
      JWT.encode({  username: admin&.username },Rails.application.secrets.secret_key_base, 'HS256')
    end
  end
end

