# === app/admin/users.rb ===
ActiveAdmin.register User do
  # 管理画面で入力可能な属性
  permit_params :email, :password, :password_confirmation, :confirmed_at, :admin

  # ==== スコープ ====
  scope :all, default: true
  scope('未確認')          { |q| q.where(confirmed_at: nil) }
  scope('未確認(3日超)')   { |q| q.where(confirmed_at: nil).where('created_at < ?', 3.days.ago) }
  scope('PWDなし')          { |q| q.where(encrypted_password: [nil, '']) }
  scope('孤児')             { |q| q.left_outer_joins(:novels).where(novels: { id: nil }) }

  # ==== フィルタ ====
  filter :email
  filter :confirmed_at, label: '確認日時'
  filter :created_at

  # ==== インデックス ====
ActiveAdmin.register User do
  index do
    id_column
    column :email
    column(:状態) do |u|
      if u.confirmed_at
        status_tag :ok,      label: '確認済'
      else
        status_tag :warning, label: '未確認'
      end
    end
    column(:PWD)    { |u| u.encrypted_password.present? ? '●●●' : status_tag(:error, label: 'なし') }
    column(:作品数) { |u| u.novels.count }
    column :created_at
  end
end

  # ==== バッチアクション ====
  batch_action :confirm_now, confirm: '選択ユーザーを確認済みにしますか？' do |ids|
    User.where(id: ids).update_all(confirmed_at: Time.current, confirmation_sent_at: Time.current)
    redirect_to collection_path, notice: '選択ユーザーを確認済みにしました'
  end

  # ==== 個別アクション ====
  member_action :confirm_now, method: :post do
    resource.update!(confirmed_at: Time.current, confirmation_sent_at: Time.current)
    redirect_back fallback_location: resource_path, notice: '確認済みにしました'
  end

  member_action :reset_password, method: :post do
    resource.send_reset_password_instructions
    redirect_back fallback_location: resource_path, notice: 'リセットメールを送信しました'
  end

  action_item :reset_password, only: :show do
    link_to 'パスワード再設定', reset_password_admin_user_path(resource), method: :post if authorized?(:reset_password, resource)
  end

  action_item :confirm_force, only: :show do
    unless resource.confirmed_at
      link_to '強制確認', confirm_now_admin_user_path(resource), method: :post
    end
  end
end