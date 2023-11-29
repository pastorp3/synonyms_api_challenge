# app/graphql/mutations/admin_login.rb
module Mutations
  class AdminLogin < BaseMutation
    argument :username, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(username:, password:)
      admin = Admin.find_by(username: username)

      if admin&.password == password
        token = JWT.encode({ id: admin.id }, Rails.application.secrets.secret_key_base)
        { token: token, errors: [] }
      else
        { token: nil, errors: ['Invalid username or password'] }
      end
    end
  end
end
