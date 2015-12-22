class User < ActiveRecord::Base
  has_many :games, foreign_key: 'player_1_id'
  has_many :games, foreign_key: 'player_2_id'
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
end
