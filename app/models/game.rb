class Game < ActiveRecord::Base
  belongs_to :player_1, class_name: 'User'
  belongs_to :player_2, class_name: 'User'
  belongs_to :board

  validates :player_1, presence: true
  validates :player_2, presence: true, allow_nil: true
  validates :board, presence: true

  before_validation :default_values, on: :create
  before_save :update_status

  delegate :set_cell, to: :board
  delegate :get_cell, to: :board

  def get_move(human_move)
    human_move_to_coordinate(human_move)
  end

  def game_over
    [:winner, :tie].include?(board.status)
  end

  def game_over_message(user_id)
    if board.status == :winner
      return "You won!" if board.winning_player == :player_1 && user_id == self.player_1_id
      return "You won!" if board.winning_player == :player_2 && user_id == self.player_2_id
      return "You lost"
    end
    return "It's a tie" if board.status == :tie
    'Game in Progress'
  end

  def default_values
    board = Board.new
    board.save
    self.board = board
    self.status = board.status
  end

  def update_status
    self.status = board.status
  end

  def play(user_id, location)
    x, y = get_move(location)
    move = self.player_1_id == user_id ? 'x' : 'o'
    board.set_cell(x, y, move)
  end

  def has_user(user_id)
    [self.player_1_id, self.player_2_id].include?(user_id)
  end

  def next_player
    return self.player_1_id if board.next_player == :player_1
    self.player_2_id
  end

  private

  def human_move_to_coordinate(human_move)
    {
      '1' => [0, 0], '2' => [1, 0], '3' => [2, 0],
      '4' => [0, 1], '5' => [1, 1], '6' => [2, 1],
      '7' => [0, 2], '8' => [1, 2], '9' => [2, 2]
    }[human_move]
  end
end
