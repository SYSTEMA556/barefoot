# === app/admin/dashboard.rb ===
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: 'ダッシュボード'

  content title: 'サイト統計' do
    columns do
      column do
        panel 'ユーザー統計' do
          para "総ユーザー数: #{User.count}"
          para link_to("未確認ユーザー: #{User.where(confirmed_at: nil).count}", admin_users_path(scope: '未確認'))
          para link_to("未確認(3日超): #{User.where(confirmed_at: nil).where('created_at < ?', 3.days.ago).count}", admin_users_path(scope: '未確認(3日超)'))
          para link_to("PWDなしユーザー: #{User.where(encrypted_password: [nil, '']).count}", admin_users_path(scope: 'PWDなし'))
        end
      end

      column do
        panel '作品統計' do
          para "公開作品: #{Novel.published.count}"
          para "下書き作品: #{Novel.draft.count}"
          para link_to("孤児作品: #{Novel.where(user_id: nil).count}", admin_novels_path(scope: '孤児'))
        end
      end
    end
  end
end
