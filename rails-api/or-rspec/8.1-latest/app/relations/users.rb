class Users < ROM::Relation[:sql]
  schema(:users, infer: false) do
    attribute :id, Types::PG::UUID
    attribute :first_name, Types::String
    attribute :last_name, Types::String
    attribute :email, Types::String
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time

    primary_key :id

    associations do
      has_many :accounts, foreign_key: :owner_id
    end
  end

  def by_email(email)
    where(Sequel.function(:lower, :email) => email.to_s.downcase)
  end
end
