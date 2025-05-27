# === app/admin/broken.rb ===
ActiveAdmin.register_page 'Broken' do
  menu priority: 2, label: '壊れデータ一覧'

  content title: '壊れユーザー / 作品' do
    columns do
      column do
        panel '未確認ユーザー(3日超)' do
          ul do
            User.where(confirmed_at: nil).where('created_at < ?', 3.days.ago).pluck(:email, :id).each do |email, id|
              li link_to "#{email}", admin_user_path(id)
            end
          end
        end

        panel 'パスワードなしユーザー' do
          ul do
            User.where(encrypted_password: [nil, '']).pluck(:email, :id).each do |email, id|
              li link_to "#{email}", admin_user_path(id)
            end
          end
        end
      end

      column do
        panel '孤児作品' do
          ul do
            Novel.where(user_id: nil).limit(20).pluck(:id, :title).each do |nid, title|
              li link_to "##{nid}: #{title.truncate(20)}", admin_novel_path(nid)
            end
          end
          para link_to '一覧へ', admin_novels_path(q: { user_id_null: 1 })
        end
      end
    end
  end
end
