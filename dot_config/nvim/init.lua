-- プラグインマネージャ
require("config.lazy")

-- オプションの設定
require('options')

-- キーマップ設定
require('keymaps')

-- プラグインをロードする
require("lazy").setup("plugins")

-- カラースキーマ
require('color_scheme')

