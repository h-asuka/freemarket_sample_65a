class Item < ApplicationRecord
  # アソシエーション
  has_one :address
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  belongs_to :user
  has_many :comments
  has_many :t_comments
  belongs_to :buyer, class_name: "User", optional: true
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  has_many :likes, dependent: :destroy
  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end

  # belongs_to :category
  has_many :item_categories
  has_many :categories, through: :item_categories

  # バリデーション
  validates :name, :text, presence: true
  validates :images, presence: true
  validate :price_limit
  validates_associated :images
  validates :genre, :status, :postage_selct, :deliver_method, exclusion: { in: ['---'] }
  validates :prefecture_id, exclusion: { in: [1] }

  def price_limit
    if price == nil
      errors.add(:price, ": out")
    elsif price < 0
      errors.add(:price, ": out")
    elsif price > 10000000
      errors.add(:price, ": out")
    elsif price >= 0 && price < 300
      errors.add(:price, ": out")
    end
  end

  def self.search(search)
    if search
      Item.where('text LIKE(?)', "%#{search}%")
    else
      Item.all
    end
  end



  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end




  


  enum genre:{
    "---":0,
    レディース:1,
    メンズ:2,
    ベビー・キッズ:3,
    インテリア・住まい・小物:4,
    本・音楽・ゲーム:5,
    おもちゃ・ホビー・グッズ:6,
    コスメ・香水・美容:7,
    家電・スマホ・カメラ:8,
    スポーツ・レジャー:9,
    ハンドメイド:10,
    チケット:11,
    自動車・オートバイ:12,
    その他:13
  },_prefix: true

  
  enum status:{
    "---":0,
    新品・未使用:1,
    未使用品に近い:2,
    目立った傷や汚れなし:3,
    やや傷や汚れあり:4,
    傷や汚れあり:5,
    全体的に状態が悪い:6
  },_prefix: true

  enum postage_selct:{
    "---":0,
    送料込み（出品者負担）:1,
    着払い（購入者負担）:2
  },_prefix: true

  enum brand:{
    "---":0,
    シャネル:1,
    ナイキ:2,
    ルイヴィトン:3,
    シュプリーム:4,
    アディダス:5,
  },_prefix: true

  enum delivery_day:{
    "---":0,
    １〜２日で発送:1,
    ２〜３日で発送:2,
    ４〜７日で発送:3
  },_prefix: true

  enum deliver_method:{
    "---":0,
    '小型サイズ - ネコポス（らくらくメルカリ便）':1,
    '小型サイズ（A4）- ゆうパケット（ゆうゆうメルカリ便）':2,
    ゆうメール:3,
    ゆうパケット:4,
    レターパック:5,
    普通郵便（定形、定形外）:6,
    クリックポスト:7
  },_prefix: true
  
  enum order:{
    並び替え:0,
    価格の安い順:1,
    価格の高い順:2,
    出品の新しい順:3,
    いいね！の多い順:4
  },_prefix: true

  enum search_genre:{
    すべて:0,
    レディース:1,
    メンズ:2,
    ベビー・キッズ:3,
    インテリア・住まい・小物:4,
    本・音楽・ゲーム:5,
    おもちゃ・ホビー・グッズ:6,
    コスメ・香水・美容:7,
    家電・スマホ・カメラ:8,
    スポーツ・レジャー:9,
    ハンドメイド:10,
    チケット:11,
    自動車・オートバイ:12,
    その他:13
  },_prefix: true

  enum search_price:{
    選択してください:0,
    "300~1000":1,
    "1000~5000":2,
    "5000~10000":3,
    "10000~30000":4,
    "30000~50000":5,
    "50000~":6
  },_prefix: true

  enum search_size:{
    すべて:0,
    洋服のサイズ:1,
    メンズ靴のサイズ:2,
    レディース靴のサイズ:3,
    スカートのサイズ:4,
    キッズ服のサイズ:5,
    ベビー・キッズ靴のサイズ:6,
    ベビー服のサイズ:7,
    テレビのサイズ:8,
    カメラレンズのサイズ:9,
    オートバイのサイズ:10,
    ヘルメットのサイズ:11,
    タイヤのサイズ:12,
    スキーのサイズ:13,
    スノーボードのサイズ:14
  },_prefix: true

  enum women:{
    トップス:0,
    'ジャケット/アウター':1,
    パンツ:2,
    スカート:3,
    ワンピース:4,
    靴:5,
    ルームウェア:6,
    帽子:7,
    バッグ:8,
    アクセサリー:9,
    ヘアアクセサリー:10,
    小物:11,
    時計:12,
  },_prefix: true
  enum men:{
    トップス:13,
    'ジャケット/アウター':14,
    パンツ:15,
    靴:16,
    バッグ:17,
    スーツ:18,
    帽子:19,
    アクセサリー:20,
    小物:21,
    時計:22,
    水着:23,
    レッグウェア:24,
    アンダーウェア:25,
    その他:26,
  },_prefix: true
  enum baby:{
    'ベビー服（女の子用）~95cm':27,
    'ベビー服（男の子用）~95cm':28,
    'ベビー服（男女兼用）~95cm':29,
    キッズ服（女の子用）:30,
    キッズ服（男の子用）:31,
    キッズ服（男女兼用）:32,
    キッズ靴:33,
    子供用ファッション小物:34,
    'おむつ/トイレ/バス':35,
    '外出/移動用品':36,
    '授乳/食事':37,
    'ベビー家具/寝具/室内用品':38,
    おもちゃ:39,
    '行事/記念品':40,
  },_prefix: true
  enum interior:{
    'キッチン/食器':41,
    'ベッド/マットレス':42,
    'ソファ/ソファベッド':43,
    '椅子/チェア':44,
    '机/テーブル':45,
    収納家具:46,
    'ラグ/カーペット/マット':47,
    'カーテン/ブラインド':48,
    'ライト/証明':49,
    寝具:50,
    インテリア小物:51,
    '季節/年中行事':52,
    その他:53,
  },_prefix: true
  enum book:{
    本:54,
    漫画:55,
    雑誌:56,
    'CD':57,
    'DVD/ブルーレイ':58,
    レコード:59,
    テレビゲーム:60,
  },_prefix: true
  enum hobby:{
    おもちゃ:61,
    タレントグッズ:62,
    'コミック/アニメグッズ':63,
    トレーディングカード:64,
    フィギュア:65,
    '楽器/機材':66,
    コレクション:67,
    ミリタリー:68,
    美術品:69,
    アート用品:70,
    その他:71,
  },_prefix: true
  enum cosmetic:{
    ベースメイク:72,
    メイクアップ:73,
    ネイルケア:74,
    香水:75,
    'スキンケア/基礎化粧品':76,
    ヘアケア:77,
    ボディケア:78,
    オーラルケア:79,
    リラクゼーション:80,
    ダイエット:81,
    その他:82,
  },_prefix: true
  enum appliance:{
    'スマートフォン/携帯':83,
    スマホアクセサリー:84,
    'PC/タブレット':85,
    カメラ:86,
    'テレビ/映像機器':87,
    オーディオ機器:88,
    '美容/健康':89,
    '冷暖房/空調':90,
    生活家電:91,
    その他:92,
  },_prefix: true
  enum sports:{
    ゴルフ:93,
    フィッシング:94,
    自転車:95,
    'トレーニング/エクササイズ':96,
    野球:97,
    'サッカー/フットサル':98,
    テニス:99,
    スノーボード:100,
    スキー:101,
    その他のスポーツ:102,
    アウトドア:103,
    その他:104,
  },_prefix: true
  enum hand_made:{
    アクセサリー（女性用）:105,
    'ファション/小物':106,
    'アクセサリー/時計':107,
    '日用品/インテリア':108,
    '趣味/おもちゃ':109,
    'キッズ/ベビー':110,
    '素材/材料':111,
    二次創作物:112,
    その他:113,
  },_prefix: true
  enum ticket:{
    音楽:114,
    スポーツ:115,
    '演技/芸能':116,
    イベント:117,
    映画:118,
    施設利用権:119,
    '優待券/割引券':120,
    その他:121,
  },_prefix: true
  enum motorcycle:{
    自動車本体:122,
    '自動車タイヤ/ホイール':123,
    自動車パーツ:124,
    自動車アクセサリー:125,
    オートバイ車体:126,
    オートバイパーツ:127,
    オートバイアクセサリー:128,
  },_prefix: true
  enum other:{
    まとめ売り:129,
    ペット用品:130,
    食品:131,
    '飲料/酒':132,
    '日用品/生活雑貨/旅行':133,
    'アンティーク/コレクション':134,
    '文房具/実務用品':135,
    '事務/店舗用品':136,
    その他:137,
  },_prefix: true

end

