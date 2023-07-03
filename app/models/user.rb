class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
   
  has_one_attached :profile_image      
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  has_many :relationship, class_name: "relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower  
  
 # validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :name, length: { in: 2..20 }
  validates :name, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
 
  def following?(user)
    following_users.include?(user)
  end	 
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
