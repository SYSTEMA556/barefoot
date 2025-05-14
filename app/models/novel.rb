class Novel < ApplicationRecord
  belongs_to :user, optional: true
   enum status: { draft: 0, published: 1 }

end
