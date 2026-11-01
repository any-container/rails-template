class AccountRepo < ROM::Repository[:accounts]
  include Timestamped
  include GeneratedId
  include ReaderWriter

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

  def create(attrs)
    owner_must_exist { accounts.command(:create).call(with_create_timestamps(without_id(attrs))) }
  end

  def update(id, attrs)
    owner_must_exist { accounts.by_pk(id).command(:update).call(with_update_timestamps(without_id(attrs))) }
  end

  def delete(id)
    accounts.by_pk(id).command(:delete).call
  end

  private

  # The savepoint keeps a caller's open transaction usable after the failure.
  def owner_must_exist(&)
    transaction(savepoint: true, &)
  rescue ROM::SQL::ForeignKeyConstraintError
    raise OwnerNotFound, "owner does not exist"
  end
end
