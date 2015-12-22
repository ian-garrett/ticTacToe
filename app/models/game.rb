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

  def game_over_message
    return 'You have won!' if board.status == :winner
    return "It's a tie" if board.status == :tie
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

  def play(move, location)
    x, y = get_move(location)
    board.set_cell(x, y, move)
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
