class Item < ApplicationRecord

  default_scope { where(deleted_at: nil) }
  scope :only_deleted, -> { unscoped.where.not(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end


end



