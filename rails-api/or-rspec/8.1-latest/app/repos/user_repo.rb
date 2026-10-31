class UserRepo < ROM::Repository[:users]
  include Timestamped

  struct_namespace Object

  def find(id)
    users.by_pk(id).one
  end

  def find!(id)
    users.by_pk(id).one!
  end

  def find_by_email(email)
    users.by_email(email).one
  end

  def all
    users.order(:created_at, :id).to_a
  end

  def create(attrs)
    users.command(:create).call(with_create_timestamps(attrs))
  end

  # Returns the updated user, or nil when the id does not exist.
  def update(id, attrs)
    users.by_pk(id).command(:update).call(with_update_timestamps(attrs))
  end

  # Returns the deleted user, or nil when the id does not exist.
  # Raises ROM::SQL::ForeignKeyConstraintError while the user still owns accounts.
  def delete(id)
    users.by_pk(id).command(:delete).call
  end
end
