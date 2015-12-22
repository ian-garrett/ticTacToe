require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { FactoryGirl.build(:game) }
  subject { game }

  it { is_expected.to respond_to(:player_1) }
  it { is_expected.to respond_to(:player_2) }
  it { is_expected.to respond_to(:board) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to validate_presence_of(:player_1) }
  # it { is_expected.to validate_presence_of(:board) }
  it { should belong_to(:player_1) }
  it { should belong_to(:player_2) }

  context '#initialize' do
    it 'initlizes a board and status message' do
      game = FactoryGirl.create(:game)
      expect(game.board.grid).to eql([['', '', ''], ['', '', ''], ['', '', '']])
      expect(game.status).to eql('Game in Progress')
    end
  end

  context '#get_move' do
    it "converts human_move of '2' to [1, 0]" do
      expect(game.get_move('2')).to eq [1, 0]
    end

    it "converts human_move of '8' to [1, 2]" do
      expect(game.get_move('8')).to eq [1, 2]
    end
  end

  context '#game_over_message' do
    let(:game) { FactoryGirl.create(:game) }
    it "returns 'You have won!' if board shows a winner" do
      allow(game.board).to receive(:status) { :winner }
      expect(game.game_over_message).to eq('You have won!')
    end

    it "returns 'The game ended in a tie' if board shows a tie" do
      allow(game.board).to receive(:status) { :tie }
      expect(game.game_over_message).to eq("It's a tie")
    end
  end

  context '#update_status' do
    it 'update status when game object is saved' do
      game = FactoryGirl.create(:game)
      expect(game.status).to eql('Game in Progress')
      allow(game.board).to receive(:status) { :winner }
      expect(game.status).to eql('Game in Progress')
      game.save
      expect(game.status).to eql('winner')
    end
  end
end
