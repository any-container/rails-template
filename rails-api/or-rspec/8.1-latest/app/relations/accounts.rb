class Accounts < ROM::Relation[:sql]
  schema(:accounts, infer: false) do
    attribute :id, Types::PG::UUID
    attribute :name, Types::String
    attribute :owner_id, Types::PG::UUID
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time

    primary_key :id

    associations do
      belongs_to :user, as: :owner, foreign_key: :owner_id
    end
  end

  def by_owner(owner_id)
    where(owner_id: owner_id)
  end
end
