class GamesController < ApplicationController
  respond_to :json

  def show
    respond_with Game.find(params[:id])
  end

  def create
    # TODO: only allow a game between two _different_ players?
    game = Game.new(game_params)

    if game.save
      render json: game, status: 201, location: [game]
    else
      render json: { errors: game.errors }, status: 422
    end
  end

  # update the game 
  def update
    game = Game.find(params[:id])

    if game.update(game_params)
      render json: game, status: 200, location: [game]
    else
      render json: { errors: game.errors }, status: 422
    end
  end

  # destroy the game (only allowed by the participants)
  def destroy
    # process the user's credentials
    return render json: { errors: ['not authenticated'] }, status: 403 unless username_and_password?
    user_id = User.authenticate(params[:username], params[:password])
    return render json: { errors: ['not authenticated'] }, status: 403 if user_id.nil?

    game = Game.find(params[:id])
    return render json: { errors: ['not a participant'] }, status: 403 unless game.has_user(user_id)

    game.destroy
    head 204
  end

  # get the person status of the game for the authenticated user
  def status
    # process the user's credentials
    return render json: { errors: ['not authenticated'] }, status: 403 unless username_and_password?
    user_id = User.authenticate(params[:username], params[:password])
    return render json: { errors: ['not authenticated'] }, status: 403 if user_id.nil?

    # find the game and respond with the personal status message
    game = Game.find(params[:id])
    render json: { status: game.game_over_message(user_id) }, status: 200
  end

  # make an authenticated move on the current game
  def make_move
    # process the user's credentials
    return render json: { errors: ['not authenticated'] }, status: 403 unless username_and_password?
    user_id = User.authenticate(params[:username], params[:password])
    return render json: { errors: ['not authenticated'] }, status: 403 if user_id.nil?

    # find the game and verify that the game is still going and that the user should make the next move
    game = Game.find(params[:id])
    return render json: { errors: ['not a participant'] }, status: 403 unless game.has_user(user_id)
    return render json: { errors: ['game already over'] }, status: 422 if game.game_over
    return render json: { errors: ['not your turn'] }, status: 422 unless game.next_player() == user_id
    return render json: { errors: ['location is required'] }, status: 422 unless params[:location].present?

    # attempt to play the provided move
    result = game.play(user_id, params[:location].to_s)

    # alert the user if they made a bad move
    return render json: { errors: ['bad move'] }, status: 422 if result == :unable_to_set

    # save otherwise
    if game.save
      render json: game, status: 201, location: [game]
    else
      render json: { errors: game.errors }, status: 422
    end
  end

  private

  # check if both a username and password were provided
  def username_and_password?
    params[:username].present? && params[:password].present?
  end

  def game_params
    params.require(:game).permit(:player_1_id, :player_2_id, :move, :location)
  end
end
