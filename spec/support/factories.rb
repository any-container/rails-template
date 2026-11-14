# Test data factories. Definitions live in spec/support/factories/.
Factory = ROM::Factory.configure { |config| config.rom = RomContainer.instance }.struct_namespace(Object)

Dir[Rails.root.join("spec/support/factories/*.rb")].sort.each { |file| require file }
