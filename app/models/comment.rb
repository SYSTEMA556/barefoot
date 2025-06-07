class Comment < ApplicationRecord
  belongs_to :user, optional: true
 belongs_to :novel
  has_secure_password :guest_password, validations: false
validates :guest_password, presence: true, unless: -> { user_id.present? }
validates_confirmation_of :guest_password, unless: -> { user_id.present? }

end
