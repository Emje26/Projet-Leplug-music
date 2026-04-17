class ConversationsController < ApplicationController
  before_action :authenticate_user!

  DEMO_CONVERSATIONS = {
    "1" => {
      partner: { initials: "KO", name: "KONG", role: "Beatmaker", online: true },
      messages: [
        { type: :date, text: "AUJOURD'HUI" },
        { from: :them, text: "Yo fréro, j'ai écouté ton dernier son c'est lourd 🔥", time: "14:23" },
        { from: :them, text: "T'aurais pas besoin d'un beat ?", time: "14:23" },
        { from: :me,   text: "Merci fréro ! Ouais carrément, je cherche un truc drill/trap", time: "14:25" },
        { from: :them, text: nil, time: "14:26", audio: { duration: "0:34 / 0:58", bars: [4,10,6,14,8,12,5,10,6,10,4,8], played: 8 } },
        { from: :me,   text: "Le beat est fou 🔥 C'est combien ?", time: "14:28" },
        { from: :them, text: "Tiens check mon pricing :", time: "14:30",
          card: { label: "SERVICE", title: "Beat Drill/Trap", sub: "Livraison 48h · 2 révisions", price: "50€", cta: "COMMANDER" } }
      ]
    },
    "2" => {
      partner: { initials: "SB", name: "STUDIO BARBÈS", role: "Studio · Paris 18e", online: false },
      messages: [
        { type: :date, text: "HIER" },
        { from: :them, text: "Salut ! Bienvenue au Studio Barbès. Comment je peux t'aider ?", time: "18:45" },
        { from: :me,   text: "Salut ! J'aimerais booker pour enregistrer un morceau rap. Cabine vocale dispo ?", time: "18:47" },
        { from: :them, text: "Oui ! Cabine traitée + Neumann U87. Tu veux quand ?", time: "18:50" },
        { from: :them, text: nil, time: "18:52",
          card: { label: "RÉSERVATION", title: "Session 3h — Cabine vocale", sub: "Mar 22 Avr · 14h", price: "74.75€", cta: "CONFIRMER" } },
        { from: :me,   text: "Parfait, je confirme !", time: "18:53" },
        { type: :system, text: "✓ Réservation confirmée" },
        { from: :them, text: "Nickel ! L'adresse exacte t'a été envoyée. À mardi 📍", time: "18:55" }
      ]
    },
    "3" => {
      partner: { initials: "PL", name: "PIELO", role: "Producteur · il y a 2h", online: false },
      messages: [
        { type: :date, text: "LUN 14 AVR" },
        { from: :them, text: "Écoute ce que j'ai fait hier soir", time: "22:15",
          track: { title: "Nuit Blanche (demo)", duration: "2:47", bpm: "140 BPM", genre: "Trap" } },
        { from: :me, text: nil, time: "22:18", audio: { duration: "0:12", bars: [6,12,8,14,10,6,12,8,10,14,6,8], played: 12 } },
        { from: :me, text: "C'est chaud frère, on fait la collab ?", time: "22:18" },
        { from: :them, text: "Carrément ! Voilà ce que je propose :", time: "22:20",
          card: { label: "PROPOSITION COLLAB", title: "Nuit Blanche ft. Toi", sub: "Pielo 60% — Toi 40%", price: nil, cta: "ACCEPTER", cta2: "MODIFIER" } }
      ]
    }
  }.freeze

  def show
    @convo = DEMO_CONVERSATIONS[params[:id].to_s]
    unless @convo
      redirect_to chats_path, alert: "Conversation introuvable." and return
    end
    @partner  = @convo[:partner]
    @messages = @convo[:messages]
  end
end
