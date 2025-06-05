class SessionsController < ApplicationController
  def new
  end

  def create
    pseudo = params[:pseudo]
    @user = User.find_or_create_by(pseudo: pseudo)
    session[:user_id] = @user.id
    redirect_to root_path, notice: "Bienvenue #{@user.pseudo}!"
  end

  def destroy
    session.delete(:user_id) # Supprime l'utilisateur de la session
    redirect_to login_path, notice: "Vous êtes déconnecté."
  end
end