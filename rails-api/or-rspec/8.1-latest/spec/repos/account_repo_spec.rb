require "rails_helper"

RSpec.describe AccountRepo do
  subject(:repo) { described_class.writer }

  let(:owner) { UserRepo.writer.create(first_name: "Ada", last_name: "Lovelace", email: "ada@example.com") }

  describe "#create" do
    it "returns an Account for an existing owner" do
      account = repo.create(name: "Acme", owner_id: owner.id)

      expect(account).to be_a(Account)
      expect(account.owner_id).to eq(owner.id)
      expect(account.id).to match(/\A\h{8}-\h{4}-4\h{3}-[89ab]\h{3}-\h{12}\z/)
      expect(account.created_at).to eq(account.updated_at)
    end

    it "raises OwnerNotFound when the owner does not exist" do
      expect { repo.create(name: "Acme", owner_id: SecureRandom.uuid) }
        .to raise_error(AccountRepo::OwnerNotFound)
    end

    it "does not insert the account when the owner does not exist" do
      repo.create(name: "Acme", owner_id: SecureRandom.uuid) rescue AccountRepo::OwnerNotFound

      expect(repo.all).to be_empty
    end
  end

  describe "#find, #find!, #all, #for_owner" do
    let!(:account) { repo.create(name: "Acme", owner_id: owner.id) }

    it "finds by id" do
      expect(repo.find(account.id)).to eq(account)
    end

    it "returns nil for an unknown id" do
      expect(repo.find(SecureRandom.uuid)).to be_nil
    end

    it "raises from find! for an unknown id" do
      expect { repo.find!(SecureRandom.uuid) }.to raise_error(ROM::TupleCountMismatchError)
    end

    it "lists all accounts" do
      expect(repo.all).to eq([account])
    end

    it "lists only the accounts of the given owner" do
      other = UserRepo.writer.create(first_name: "Grace", last_name: "Hopper", email: "grace@example.com")
      repo.create(name: "Other", owner_id: other.id)

      expect(repo.for_owner(owner.id)).to eq([account])
    end
  end

  describe "#update" do
    let!(:account) { repo.create(name: "Acme", owner_id: owner.id) }

    it "changes the attributes and moves updated_at forward" do
      updated = repo.update(account.id, name: "Acme Inc", created_at: Time.at(0))

      expect(updated.name).to eq("Acme Inc")
      expect(updated.created_at).to eq(account.created_at)
      expect(updated.updated_at).to be > account.updated_at
    end

    it "raises OwnerNotFound when moved to an owner that does not exist" do
      expect { repo.update(account.id, owner_id: SecureRandom.uuid) }
        .to raise_error(AccountRepo::OwnerNotFound)
    end

    it "returns nil for an unknown id" do
      expect(repo.update(SecureRandom.uuid, name: "x")).to be_nil
    end
  end

  describe "#delete" do
    let!(:account) { repo.create(name: "Acme", owner_id: owner.id) }

    it "deletes and returns the account" do
      expect(repo.delete(account.id)).to eq(account)
      expect(repo.find(account.id)).to be_nil
    end

    it "returns nil for an unknown id" do
      expect(repo.delete(SecureRandom.uuid)).to be_nil
    end
  end
end
