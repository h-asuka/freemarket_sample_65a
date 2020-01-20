class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :sns_credentials, dependent: :destroy 
  has_many :likes

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, 
          :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  def self.without_sns_data(auth)
    user = User.where(email: auth.info.email).first 

      if user.present?
        sns = SnsCredential.create( 
          uid: auth.uid,
          provider: auth.provider, 
          user_id: user.id
        )
      else
        user = User.new(
          nickname: auth.info.name,
          email: auth.info.email, 
        )
        sns = SnsCredential.new(
          uid: auth.uid,
          provider: auth.provider 
        )
      end
      return { user: user ,sns: sns} 
    end

   def self.with_sns_data(auth, snscredential) 
    user = User.where(id: snscredential.user_id).first
    unless user.present? 
      user = User.new(
        nickname: auth.info.name,
        email: auth.info.email, 
      )
    end
    return {user: user}
   end 

   def self.find_oauth(auth)
    uid = auth.uid 
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first 
    if snscredential.present?
      user = with_sns_data(auth, snscredential)[:user] 
      sns = snscredential
    else
      user = without_sns_data(auth)[:user] 
      sns = without_sns_data(auth)[:sns]
    end 
    return { user: user ,sns: sns}
  end 

  def already_liked?(item)
    self.likes.exists?(item_id: item.id)
  end

  def eva(user)
    num = 0
    self.items.each do |item|
      if item.evaluation.present?
        num += 1
      end
    end
    num
  end
  has_one  :address
  has_one  :number
  has_many :cards
  has_many :items, -> { order('created_at DESC') }
  has_many :comments
  has_many :t_comments

  mount_uploader :avatar_image, ImageUploader

  validates :nickname, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/ }
  validates :password, presence: true, length: { minimum: 7 }, on: :create
  validates :last_name, presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]/ }
  validates :first_name, presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]/ }
  validates :last_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :first_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }





  # 商品出品中
  has_many :selling_items, -> { where("buyer_id is NULL") }, class_name: "Item"
  # 交渉中
  has_many :nagotiations_items, -> { where("buyer_id is not NULL && sold is NULL")}, class_name: "Item"
  # 商品売却済
  has_many :sold_items, -> { where("buyer_id is not NULL && sold is not NULL") }, class_name: "Item"

  has_many :buyed_items, foreign_key: "buyer_id", class_name: "Item"
end