# config/initializers/ransack_acts_as_taggable_on.rb
ActsAsTaggableOn::Tag.class_eval do
  # Ransackで検索可能なタグの属性を明示的に許可
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      name
      created_at
      updated_at
      taggings_count
    ]
  end
end
