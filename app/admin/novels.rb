# === app/admin/novels.rb ===
ActiveAdmin.register Novel do
  permit_params :title, :body, :status, :user_id

  scope :all, default: true
  scope('下書き') { |q| q.where(status: :draft) }
  scope('公開')   { |q| q.where(status: :published) }
  scope('孤児')   { |q| q.where(user_id: nil) }

  filter :title
  filter :user, collection: proc { User.pluck(:email, :id) }
  filter :status, as: :select, collection: Novel.statuses

index do
  selectable_column
  id_column
  column :title
  column(:作者) { |n| n.user&.email || status_tag('作者不明', class: 'warning') }
  column :status
  column :created_at
  actions
end

  batch_action :archive_orphans, confirm: '孤児作品を archive にしますか？' do |ids|
    Novel.where(id: ids).update_all(status: :archived)
    redirect_to collection_path, notice: '孤児作品を archived にしました'
  end
end
