import { createConsumer } from "@rails/actioncable";

const consumer = createConsumer();

// Lorsque le DOM est complètement chargé
document.addEventListener("DOMContentLoaded", () => {
  console.error("✅ DOM entièrement chargé, lancement du script ActionCable.");

  // Trace globale pour capturer les erreurs
  window.onerror = function (message, source, lineno, colno, error) {
    console.error("🚨 Erreur détectée :", message);
    console.error(`📍 Source : ${source} (ligne ${lineno}, colonne ${colno})`);
  };

  // Fonction créée pour générer le canal GameChannel
  function createGameChannel(gameSessionId) {
    const subscription = consumer.subscriptions.create(
      { channel: "GameChannel", game_session_id: gameSessionId },
      {
        connected: function () {
          console.log(`✅ Connecté au GameChannel pour la session ${gameSessionId}`);
        },
        disconnected: function () {
          console.warn(`⚠️ Déconnecté du GameChannel pour la session ${gameSessionId}`);
        },
        received: function (data) {
          console.log("📡 Données reçues :", data);

          if (!data || typeof data !== "object") {
            console.error("❌ Erreur : Données reçues invalides !");
            return;
          }

          // Mise à jour du message
          const messageElement = document.getElementById("game-message");
          if (messageElement && data.message) {
            messageElement.innerHTML = data.message;
          }

          // Mise à jour du score (vérification avancée)
          const scoreElementId = `score-${data.user_id}`;
          console.log(`🔍 Recherche de l'élément avec ID "${scoreElementId}"`);
          const scoreElement = document.getElementById(scoreElementId);
          console.log("📡 Élément trouvé :", scoreElement);

          if (!scoreElement) {
            console.error(`❌ Erreur : L'élément avec ID "${scoreElementId}" est introuvable !`, data);
            return;
          }

          if (data.score !== undefined) {
            const newScore = parseInt(data.score, 10);
            if (!isNaN(newScore)) {
              scoreElement.innerHTML = newScore;
            } else {
              console.error("❌ Erreur : Score reçu invalide.", data.score);
            }
          }
        }
      }
    );

    console.log("🛠 Vérification de subscription :", subscription);
    return subscription;
  }

  // Fonction utilitaire externe pour envoyer la réponse
  function submitAnswer(channel, answerData) {
    console.log("📡 submitAnswer (fonction utilitaire) appelée avec :", answerData);
    if (!channel.perform || typeof channel.perform !== "function") {
      console.error("❌ Erreur : channel.perform n'est pas défini ou n'est pas une fonction !");
      return Promise.reject(new Error("Impossible d'envoyer la réponse : channel.perform est invalide"));
    }
    try {
      channel.perform("submit_answer", answerData);
      console.log("✅ channel.perform appelé correctement, renvoi d'une Promise résolue.");
      // Retourne toujours une Promise résolue (même si perform ne renvoie rien)
      return Promise.resolve("Réponse envoyée");
    } catch (error) {
      console.error("❌ Erreur lors de l'appel à channel.perform :", error);
      return Promise.reject(error);
    }
  }

  // Création d'une GameChannel pour la session "test_session"
  const channel = createGameChannel("test_session");
  console.log("👉 Objet channel :", channel);

  // Exemple d'envoi de réponse via la fonction utilitaire
  const answerData = { user_id: 1, answer_correct: true };
  const promise = submitAnswer(channel, answerData);
  console.log("👉 Promesse retournée par submitAnswer :", promise);

  promise
    .then((res) => {
      console.log("✅ then appelé, résultat :", res);
    })
    .catch((error) => {
      console.error("❌ catch appelé, erreur :", error);
    });
});
