# Sets created_at and updated_at for repos.
# Timestamps are always set here, never taken from the caller.
module Timestamped
  extend ActiveSupport::Concern

  PROTECTED_ATTRIBUTES = %i[created_at updated_at].freeze

  private

  def with_create_timestamps(attrs, now: Time.now.utc)
    attrs.except(*PROTECTED_ATTRIBUTES).merge(created_at: now, updated_at: now)
  end

  def with_update_timestamps(attrs, now: Time.now.utc)
    attrs.except(*PROTECTED_ATTRIBUTES).merge(updated_at: now)
  end
end
