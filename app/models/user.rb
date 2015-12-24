class User < ActiveRecord::Base
  has_many :games, foreign_key: 'player_1_id'
  has_many :games, foreign_key: 'player_2_id'
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

    def self.authenticate(username, password)
    user = User.find_by(username: username)
    return user.id if user && user.password == password
  end
end
