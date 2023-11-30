module Authorization
  def require_admin_access
    raise GraphQL::ExecutionError, 'Access denied. Admin privileges required.' unless context[:current_admin]
  end
end
