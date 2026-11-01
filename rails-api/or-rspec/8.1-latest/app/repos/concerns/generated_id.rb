# The database generates ids. Callers cannot supply them on create or update.
module GeneratedId
  extend ActiveSupport::Concern

  private

  def without_id(attrs)
    attrs.except(:id)
  end
end
