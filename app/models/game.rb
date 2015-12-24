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

  # check whether the game has completed
  def game_over
    [:winner, :tie].include?(board.status)
  end

  # this returns a message to display to the given user id
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

  # the update status method updates the status of the game in the database to match the board's status
  def update_status
    self.status = board.status
  end

  # play calculates the move from the user id and plays to that location, returns :unable_to_set if the cell is full
  def play(user_id, location)
    x, y = get_move(location)
    move = self.player_1_id == user_id ? 'x' : 'o'
    board.set_cell(x, y, move)
  end

  # verify user
  def has_user(user_id)
    [self.player_1_id, self.player_2_id].include?(user_id)
  end

  # returns the user id for the player who needs to move next
  def next_player
    return self.player_1_id if board.next_player == :player_1
    self.player_2_id
  end

  private

  # translates the human tic-tac-toe move to an (x,y) coordinate
  def human_move_to_coordinate(human_move)
    {
      '1' => [0, 0], '2' => [1, 0], '3' => [2, 0],
      '4' => [0, 1], '5' => [1, 1], '6' => [2, 1],
      '7' => [0, 2], '8' => [1, 2], '9' => [2, 2]
    }[human_move]
  end
end
