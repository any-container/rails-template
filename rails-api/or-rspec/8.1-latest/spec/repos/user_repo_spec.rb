require "rails_helper"

RSpec.describe UserRepo do
  subject(:repo) { described_class.new(RomContainer.instance) }

  let(:attrs) { {first_name: "Ada", last_name: "Lovelace", email: "ada@example.com"} }

  describe "#create" do
    it "returns a User with a UUID v4 id" do
      user = repo.create(attrs)

      expect(user).to be_a(User)
      expect(user.id).to match(/\A\h{8}-\h{4}-4\h{3}-[89ab]\h{3}-\h{12}\z/)
      expect(user.full_name).to eq("Ada Lovelace")
    end

    it "sets created_at and updated_at to the same UTC time" do
      user = repo.create(attrs)

      expect(user.created_at).to be_a(Time)
      expect(user.created_at).to eq(user.updated_at)
      expect(user.created_at).to be_within(5).of(Time.now.utc)
    end

    it "ignores timestamps given by the caller" do
      user = repo.create(attrs.merge(created_at: Time.at(0), updated_at: Time.at(0)))

      expect(user.created_at).to be > Time.at(0)
      expect(user.updated_at).to be > Time.at(0)
    end

    it "ignores an id given by the caller" do
      given = SecureRandom.uuid

      expect(repo.create(attrs.merge(id: given)).id).not_to eq(given)
    end

    it "rejects an email that differs only by case" do
      repo.create(attrs)

      expect { repo.create(attrs.merge(email: "ADA@example.com")) }
        .to raise_error(ROM::SQL::UniqueConstraintError)
    end
  end

  describe "#find, #find!, #find_by_email" do
    let!(:user) { repo.create(attrs) }

    it "finds by id" do
      expect(repo.find(user.id)).to eq(user)
    end

    it "returns nil for an unknown id" do
      expect(repo.find(SecureRandom.uuid)).to be_nil
    end

    it "raises from find! for an unknown id" do
      expect { repo.find!(SecureRandom.uuid) }.to raise_error(ROM::TupleCountMismatchError)
    end

    it "finds by email ignoring case" do
      expect(repo.find_by_email("ADA@Example.com")).to eq(user)
    end
  end

  describe "#all" do
    it "returns users oldest first" do
      first = repo.create(attrs)
      second = repo.create(attrs.merge(email: "grace@example.com"))

      expect(repo.all.map(&:id)).to eq([first.id, second.id])
    end
  end

  describe "#update" do
    let!(:user) { repo.create(attrs) }

    it "changes the attributes and moves updated_at forward" do
      updated = repo.update(user.id, first_name: "Grace", created_at: Time.at(0))

      expect(updated.first_name).to eq("Grace")
      expect(updated.created_at).to eq(user.created_at)
      expect(updated.updated_at).to be > user.updated_at
    end

    it "ignores an id given by the caller" do
      expect(repo.update(user.id, id: SecureRandom.uuid).id).to eq(user.id)
    end

    it "returns nil for an unknown id" do
      expect(repo.update(SecureRandom.uuid, first_name: "Grace")).to be_nil
    end
  end

  describe "#delete" do
    let!(:user) { repo.create(attrs) }

    it "deletes and returns the user" do
      expect(repo.delete(user.id)).to eq(user)
      expect(repo.find(user.id)).to be_nil
    end

    it "returns nil for an unknown id" do
      expect(repo.delete(SecureRandom.uuid)).to be_nil
    end

    it "refuses to delete a user who owns an account" do
      AccountRepo.new(RomContainer.instance).create(name: "Acme", owner_id: user.id)

      expect { repo.delete(user.id) }.to raise_error(ROM::SQL::ForeignKeyConstraintError)
    end
  end
end
