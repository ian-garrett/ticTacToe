require 'array_core_extensions'

class Board < ActiveRecord::Base
  serialize :grid
  before_create :default_grid

  def get_cell(x, y)
    grid[y][x]
  end

  def set_cell(x, y, value)
    if get_cell(x, y).blank?
      grid[y][x] = value
      save
    else
      :unable_to_set
    end
  end

  # returns the current status of the game - whether the game is over, and the result of the game
  def status
    return :winner if winner?
    return :tie if tie?
    'Game in Progress'
  end

  # returns :player_1 or :player_2 depending on who won
  def winning_player
    return :player_1 if who_won == 'x'
    :player_2
  end

  # returns :player_1 or :player_2 depending on who needs to play next (based on the number of x's and o's already on the board)
  def next_player
    count1 = 0
    count2 = 0
    grid.flatten.each do |move|
      count1 += 1 if move == 'x'
      count2 += 1 if move == 'o'
    end
    return :player_1 if count1 <= count2
    :player_2
  end

  private

  def default_grid
    self.grid ||= Array.new(3) { Array.new(3) { '' } }
  end

  def tie?
    grid.flatten.none_empty?
  end

  # returns true if someone has won
  def winner?
    winning_combinations.each do |winning_position|
      next if winning_position.all_empty?
      return true if winning_position.all_same?
    end
    false
  end

  # returns the 'x' or 'o' corresponding to the winner, or nil if nobody has won
  def who_won
    winning_combinations.each do |winning_position|
      next if winning_position.all_empty?
      return winning_position[0] if winning_position.all_same?
    end
  end

  def winning_combinations
    rows + columns + diagonals
  end

  def rows
    grid
  end

  def columns
    grid.transpose
  end

  def diagonals
    [left_diagonal, right_diagonal]
  end

  def left_diagonal
    [get_cell(0, 0), get_cell(1, 1), get_cell(2, 2)]
  end

  def right_diagonal
    [get_cell(0, 2), get_cell(1, 1), get_cell(2, 0)]
  end
end
