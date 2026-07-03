class AssistantController < ApplicationController
  before_action :authenticate_user!

  def show
    session[:assistant_messages] ||= []
    @messages = session[:assistant_messages]
  end

  def talk
    user_message = params[:message].to_s.strip

    if user_message.blank?
      redirect_to assistant_path, alert: "Écris d'abord un message." and return
    end

    # 1. Get history from session (or init)
    history = session[:assistant_messages] ||= []

    # 2. Add the new user message into our history
    history << { "role" => "user", "content" => user_message }

    # 3. System prompt
    system_prompt = <<~PROMPT
      Tu es PLUG/AI, l'assistant créatif de Le Plug, la marketplace qui connecte
      les artistes aux studios, beatmakers et ingénieurs son.

      TON RÔLE :
      - Aider les artistes à préparer leurs sessions : direction artistique,
        structure de morceau, choix de BPM / tonalité / instrus, références,
        checklist d'enregistrement, préparation du brief pour un ingé son.
      - Conseiller sur le choix d'une prestation (enregistrement, mixage,
        mastering, clip) et sur la façon d'en tirer le maximum en studio.

      COMPORTEMENT :
      - Réponds en français, tutoie l'utilisateur, reste concret et actionnable.
      - Sois efficace : ne pose pas trop de questions de clarification d'affilée.
        Si le brief est suffisant, propose directement une suggestion complète.
      - Si un élément clé manque, pose au maximum 1-2 questions courtes,
        puis propose quand même une piste.

      FORMAT DES SUGGESTIONS :
      Quand tu proposes une direction complète, structure ta réponse en texte
      simple avec ces sections :

      Titre de travail :
      Style / ambiance :
      BPM et tonalité :
      Structure (intro / couplets / refrains / pont / outro) :
      Ingrédients sonores :
      Références :
      Prochaine étape en studio :
    PROMPT

    # 4. Build a single conversation string from history
    conversation_text = history.map do |m|
      speaker = m["role"] == "assistant" ? "Assistant" : "User"
      "#{speaker}: #{m['content']}"
    end.join("\n\n")

    full_prompt = <<~FULL
      #{system_prompt}

      Voici la conversation entre l'utilisateur et PLUG/AI jusqu'ici :

      #{conversation_text}

      Réponds maintenant en tant que PLUG/AI au DERNIER message de l'utilisateur.
      Si c'est pertinent, donne une suggestion complète au FORMAT DES SUGGESTIONS.
    FULL

    # 5. Call RubyLLM with a single string
    chat = RubyLLM.chat
    response = chat.ask(full_prompt)

    assistant_text =
      if response.respond_to?(:content)
        response.content
      else
        response.to_s
      end

    # 6. Add assistant reply to history and save in session
    history << { "role" => "assistant", "content" => assistant_text }
    session[:assistant_messages] = history

    redirect_to assistant_path
  rescue StandardError => e
    Rails.logger.error("Assistant error: #{e.class} - #{e.message}")
    redirect_to assistant_path, alert: "Un problème est survenu avec PLUG/AI. Réessaie."
  end

  def reset
    session[:assistant_messages] = []
    redirect_to assistant_path, notice: "Chat réinitialisé."
  end
end
