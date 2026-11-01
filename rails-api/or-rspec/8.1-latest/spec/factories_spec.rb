require "rails_helper"

RSpec.describe "Factory" do
  describe ":user" do
    it "creates a persisted User" do
      user = Factory[:user]

      expect(user).to be_a(User)
      expect(UserRepo.reader.find(user.id)).to eq(user)
    end

    it "generates a unique email for each user" do
      emails = Array.new(3) { Factory[:user].email }

      expect(emails.uniq.size).to eq(3)
    end

    it "builds an unsaved User" do
      Factory.build(:user)

      expect(UserRepo.reader.all).to be_empty
    end

    it "accepts attribute overrides" do
      expect(Factory[:user, first_name: "Ada"].first_name).to eq("Ada")
    end
  end

  describe ":account" do
    it "creates an Account with a persisted owner" do
      account = Factory[:account]

      expect(account).to be_a(Account)
      expect(UserRepo.reader.find(account.owner_id)).not_to be_nil
    end

    it "uses a given owner" do
      owner = Factory[:user]

      expect(Factory[:account, owner_id: owner.id].owner_id).to eq(owner.id)
    end
  end
end
