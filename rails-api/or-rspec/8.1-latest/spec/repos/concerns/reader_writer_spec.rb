require "rails_helper"

RSpec.describe ReaderWriter do
  let(:repo_class) do
    Class.new(ROM::Repository[:users]) { include ReaderWriter }
  end

  describe ".reader" do
    it "returns an instance of the repo class" do
      expect(repo_class.reader).to be_a(repo_class)
    end

    it "builds it on the RomContainer instance" do
      expect(repo_class.reader.container).to equal(RomContainer.instance)
    end

    it "returns a new instance on every call" do
      expect(repo_class.reader).not_to equal(repo_class.reader)
    end
  end

  describe ".writer" do
    it "returns an instance of the repo class" do
      expect(repo_class.writer).to be_a(repo_class)
    end

    it "builds it on the RomContainer instance" do
      expect(repo_class.writer.container).to equal(RomContainer.instance)
    end

    it "returns a new instance on every call" do
      expect(repo_class.writer).not_to equal(repo_class.writer)
    end
  end
end
