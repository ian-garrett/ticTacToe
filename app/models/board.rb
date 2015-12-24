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
      'cannot overide cell value'
    end
  end

  def status
    return :winner if winner?
    return :tie if tie?
    'Game in Progress'
  end

  private

  def default_grid
    self.grid ||= Array.new(3) { Array.new(3) { '' } }
  end

  def tie?
    grid.flatten.none_empty?
  end

  def winner?
    winning_combinations.each do |winning_position|
      next if winning_position.all_empty?
      return true if winning_position.all_same?
    end
    false
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

  #function to decide which player should go next
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

end
