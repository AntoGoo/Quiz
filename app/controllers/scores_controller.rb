class ScoresController < ApplicationController
  def index
    @players = Player.order(high_score: :desc) # Trie les joueurs par score décroissant
  end
end