class GameSerializer < ActiveModel::Serializer

  attributes :id, :status, :board, :created_at, :updated_at

  has_one :player_1
  has_one :player_2

  def board
    object.board.grid
  end
end
