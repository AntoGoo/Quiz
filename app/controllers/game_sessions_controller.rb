class GameSessionsController < ApplicationController
  before_action :require_user

  def new
    @quiz = Quiz.find(params[:quiz_id])
    @game_session = GameSession.new(quiz: @quiz)
  end

  def create
    @quiz = Quiz.find(params[:quiz_id])
    # Initialise une session de jeu active
    @game_session = GameSession.create!(quiz: @quiz, status: "active")
    # Crée la participation pour l'utilisateur courant
    Participation.create(user: current_user, game_session: @game_session, score: 0)
    redirect_to game_session_path(@game_session)
  end

  def show
    @game_session = GameSession.find(params[:id])
    @questions = @game_session.quiz.questions.order("RANDOM()").limit(@game_session.quiz.num_questions_per_game)
    #charge la première question du quiz
    @current_question = @questions.first
    @participation ||= Participation.find_or_create_by(user: current_user, game_session: @game_session)
    @participation&.reload
  end
  

  # Méthode alternative pour gérer la soumission d'une réponse via une requête HTTP
  def submit_answer
    @game_session = GameSession.find(params[:id])
    participation = Participation.find_or_create_by(user: current_user, game_session: @game_session)
    
    # Identifiant de l'option soumise
    option = Option.find(params[:option_id])
    if option.correct?
      participation.score ||= 0
      participation.score += 1
      participation.save
      flash[:notice] = "Réponse correcte !"
    else
      flash[:alert] = "Réponse incorrecte."
    end
    redirect_to game_session_path(@game_session), notice: "Score mis à jour !"
  end

  private

  def require_user
    redirect_to login_path, alert: "Veuillez vous connecter" unless current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
