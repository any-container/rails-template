# Builds repo instances for reading and writing.
# There is no reader database yet, so both use the same container.
module ReaderWriter
  extend ActiveSupport::Concern

  class_methods do
    def reader
      new(RomContainer.instance)
    end

    def writer
      new(RomContainer.instance)
    end
  end
end
