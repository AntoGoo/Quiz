module Admin
  class QuizzesController < ApplicationController
    #before_action :authenticate_admin!

    def index
      @quizzes = Quiz.all
    end

    def new
      @quiz = Quiz.new
      num_questions = params[:num_questions].to_i.nonzero? || 3 # Valeur par défaut si non spécifiée
  
      num_questions.times do
        question = @quiz.questions.build
        2.times { question.options.build } # Chaque question aura 8 options
  end
    end
    
    def show
      @quiz = Quiz.find(params[:id])
    end

    def create
      @quiz = Quiz.new(quiz_params)
      if @quiz.save
        redirect_to new_player_path, notice: "Quiz créé avec succès"
      else
        Rails.logger.debug "Erreurs du quiz : #{@quiz.errors.full_messages}"
        flash[:alert] = @quiz.errors.full_messages.join(", ")
        render :new #, status: :unprocessable_entity
      end
    end

    def edit
      @quiz = Quiz.find(params[:id])
    end

    def update
      @quiz = Quiz.find(params[:id])
      if @quiz.update(quiz_params)
        redirect_to admin_quizzes_path, notice: "Quiz mis à jour"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @quiz = Quiz.find(params[:id])
      if @quiz.destroy
        redirect_to admin_quizzes_path, notice: "Quiz supprimé avec succès."
      else
        redirect_to admin_quizzes_path, alert: "Erreur lors de la suppression du quiz."
    end
    end

    private

    def quiz_params
      Rails.logger.debug "Paramètres reçus : #{params.inspect}"
      params.require(:quiz).permit(:title, :description, :num_questions, 
        questions_attributes: [:id, :content, :_destroy, options_attributes: [:id, :content, :correct, :_destroy]])
    end


    #def authenticate_admin!
      # Remplace cette logique par ta méthode d'authentification des administrateurs
      #redirect_to root_path, alert: "Accès refusé" unless current_user && current_user.admin?
    #end
  end
end
