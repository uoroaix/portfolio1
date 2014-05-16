class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_one :profile, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy


  delegate :full_name, to: :profile
  delegate :id, to: :profile, prefix: true

end
