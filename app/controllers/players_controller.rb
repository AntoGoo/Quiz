class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create
    @player = Player.find_or_create_by(pseudo: params[:player][:pseudo])
    redirect_to root_path, notice: "Bienvenue, #{@player.pseudo} !"
  end
end