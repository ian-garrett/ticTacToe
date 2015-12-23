class GamesController < ApplicationController
  respond_to :json

  def show
    respond_with Game.find(params[:id])
  end

  def create
    game = Game.new(game_params)

    if game.save
      render json: game, status: 201, location: [game]
    else
      render json: { errors: game.errors }, status: 422
    end
  end

  def update
    game = Game.find(params[:id])

    if game.update(game_params)
      render json: game, status: 200, location: [game]
    else
      render json: { errors: game.errors }, status: 422
    end
  end

  def destroy
    Game.find(params[:id]).destroy
    head 204
  end

  def make_move
    game = Game.find(params[:id])
    return render json: { errors: 'move and location are required' }, status: 422 unless move_and_location?
    game.play(params[:move].to_s, params[:location].to_s)
    if game.save
      render json: [game,"GAME STATUS: "+game.game_over_message], status: 201
    else
      render json: { errors: game.errors }, status: 422
    end
  end

  private

  def move_and_location?
    params[:move].present? && params[:location].present?
  end

  def game_params
    params.require(:game).permit(:player_1_id, :player_2_id, :move, :location)
  end

  def status #function to check if a user has won the game
    game = Game.find(params[:id])
    render json: game.game_over_message, status: 200
  end

end
