module Mutations
  class AdminLogin < BaseMutation
    argument :user, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(user:, password:)
      admin = Admin.find_by(username: user)

      if admin&.authenticate(password)
        token = admin&.generate_token
        { token: token, errors: [] }
      else
        { token: nil, errors: ['Invalid username or password'] }
      end
    end
  end
end

