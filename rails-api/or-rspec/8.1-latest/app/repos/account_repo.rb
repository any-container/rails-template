class AccountRepo < ROM::Repository[:accounts]
  include Timestamped

  # Raised when owner_id does not point to an existing user.
  class OwnerNotFound < StandardError; end

  struct_namespace Object

  def find(id)
    accounts.by_pk(id).one
  end

  def find!(id)
    accounts.by_pk(id).one!
  end

  def all
    accounts.order(:created_at, :id).to_a
  end

  def for_owner(owner_id)
    accounts.by_owner(owner_id).order(:created_at, :id).to_a
  end

  # The owner must already exist. The foreign key enforces it, so there is no
  # check-then-insert race.
  def create(attrs)
    owner_must_exist { accounts.command(:create).call(with_create_timestamps(attrs)) }
  end

  # Returns the updated account, or nil when the id does not exist.
  def update(id, attrs)
    owner_must_exist { accounts.by_pk(id).command(:update).call(with_update_timestamps(attrs)) }
  end

  def delete(id)
    accounts.by_pk(id).command(:delete).call
  end

  private

  def owner_must_exist
    yield
  rescue ROM::SQL::ForeignKeyConstraintError
    raise OwnerNotFound, "owner does not exist"
  end
end
