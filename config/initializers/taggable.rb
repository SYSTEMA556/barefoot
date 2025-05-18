
require 'acts-as-taggable-on'

ActsAsTaggableOn.setup do |config|
  # 半角スペース・全角スペースの両方を区切り文字に
  config.delimiter = /[[:space:]\u3000]+/

  # 同じタグを大小文字で重複させないために小文字化
  config.force_lowercase = true
end
