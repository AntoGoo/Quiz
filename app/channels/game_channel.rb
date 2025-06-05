class GameChannel < ApplicationCable::Channel
  def subscribed
    game_session = GameSession.find(params[:game_session_id])
    stream_for game_session
  end

  def unsubscribed
    # Toute action à réaliser lors de la déconnexion
  end

  # Reçoit la réponse d'un utilisateur
  def submit_answer(data)
    game_session = GameSession.find(params[:game_session_id])
    participation = Participation.find_by(user_id: data["user_id"], game_session_id: game_session.id)
    
    # Exemple de logique basique : data["answer_correct"] est true/false
    if data["answer_correct"]
      participation.score += 1
      participation.save
      GameChannel.broadcast_to(game_session, { 
         user_id: data["user_id"], 
         score: participation.score,
         message: "Réponse correcte !"
      })
    else
      GameChannel.broadcast_to(game_session, { 
         user_id: data["user_id"], 
         score: participation.score,
         message: "Réponse incorrecte."
      })
    end
  end
end
