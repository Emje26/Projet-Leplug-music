puts "Seeding the database..."

user = User.find_or_create_by!(email: 'jo_sample@example.com') do |u|
  puts "Creating initial User: jo_sample@example.com"
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

# =============================================================================
# LE PLUG — MARKETPLACE SEEDS (studios + talents)
# =============================================================================
# Idempotent: wipes and rebuilds the marketplace tables on every run so the
# seeds stay in sync with the fixture data below. Does NOT touch anything
# outside the marketplace (users, profiles, etc.).
# =============================================================================

puts "\n--- Wiping marketplace tables... ---"
Review.delete_all  if defined?(Review)
Booking.delete_all if defined?(Booking)
Studio.delete_all  if defined?(Studio)
Talent.delete_all  if defined?(Talent)

# ---- Helper: create a throwaway User for each listing ----------------------
def marketplace_user!(email)
  User.find_or_create_by!(email: email) do |u|
    u.password = "password123"
    u.password_confirmation = "password123"
  end
end

# =============================================================================
# STUDIOS — 10 studios à Paris
# =============================================================================

studios_data = [
  {
    name: "Red Bull Studios Paris",
    description: "Studio iconique du 11e, plateau pro avec cabine Neumann et console SSL. Utilisé par Booba, Ninho, SCH. Ingé son inclus les weekends.",
    address: "32 Rue du Faubourg Saint-Antoine",
    city: "Paris",
    price_per_hour: 48,
    latitude: 48.8527,  longitude: 2.3716,  # Paris 11e
    rating: 4.8,
    category: "studio",
    equipment: ["Neumann U87", "SSL 4000 E", "Pro Tools HDX", "Apollo 8p", "Yamaha NS-10", "Genelec 1032"]
  },
  {
    name: "Midnight Barbès",
    description: "Home studio haut de gamme rue Myrha. Spécialisé rap et trap, bonne acoustique, vibe intimiste. Parfait pour sessions nocturnes.",
    address: "45 Rue Myrha",
    city: "Paris",
    price_per_hour: 28,
    latitude: 48.8862, longitude: 2.3508,  # Paris 18e
    rating: 4.6,
    category: "studio",
    equipment: ["Neumann TLM 103", "Apollo Twin X", "Logic Pro X", "Adam A7X", "Shure SM7B"]
  },
  {
    name: "La Cave — Studio 19",
    description: "Cave aménagée en studio pro dans le 19e. Grand live room pour batterie, bonne isolation, utilisé par des formations jazz et rap live.",
    address: "8 Rue de Crimée",
    city: "Paris",
    price_per_hour: 35,
    latitude: 48.8874, longitude: 2.3785,  # Paris 19e
    rating: 4.5,
    category: "studio",
    equipment: ["Neumann U87", "Pro Tools Ultimate", "Universal Audio Apollo x8", "NS-10", "Focal Shape 65", "Rode NT1"]
  },
  {
    name: "Atelier Pigalle Prod",
    description: "Studio de production et beatmaking avec MPC Live 2, modular rack, et bonne collection de vintage synths. Atmosphère old-school.",
    address: "14 Rue Victor Massé",
    city: "Paris",
    price_per_hour: 32,
    latitude: 48.8818, longitude: 2.3360,  # Paris 9e
    rating: 4.7,
    category: "prod",
    equipment: ["Akai MPC Live 2", "Moog Sub 37", "Roland TR-8S", "Ableton Live 11 Suite", "Yamaha HS8", "Rhodes MK1"]
  },
  {
    name: "Bastille Mix Lab",
    description: "Laboratoire de mixage et mastering. Cabine traitée Bob Katz, monitoring Focal Trio6, idéal pour un mix qui frappe en streaming.",
    address: "22 Rue de la Roquette",
    city: "Paris",
    price_per_hour: 42,
    latitude: 48.8554, longitude: 2.3727,  # Paris 11e
    rating: 4.9,
    category: "mixage",
    equipment: ["Focal Trio6 Be", "Manley Massive Passive", "API 2500", "Pro Tools HDX", "Weiss DS1-MK3", "Tube-Tech CL1B"]
  },
  {
    name: "Oberkampf Mastering",
    description: "Studio de mastering dédié. Acoustique PMC, chaîne analogique + numérique, spécialiste masterisation streaming (Spotify / Tidal / Apple).",
    address: "109 Rue Oberkampf",
    city: "Paris",
    price_per_hour: 50,
    latitude: 48.8656, longitude: 2.3776,  # Paris 11e
    rating: 4.8,
    category: "mastering",
    equipment: ["PMC IB2S", "Weiss EQ1-MK3", "Shadow Hills Mastering Compressor", "Lynx Hilo", "SPL MTC 2381"]
  },
  {
    name: "Goutte d'Or Visual",
    description: "Studio vidéo tout équipé pour clips rap. Cyclo blanc, kit lumière 12k, BMPCC 6K + Ronin RS3. Shooting 1 ou 2 jours au forfait.",
    address: "18 Rue des Islettes",
    city: "Paris",
    price_per_hour: 45,
    latitude: 48.8840, longitude: 2.3533,  # Paris 18e
    rating: 4.6,
    category: "clip",
    equipment: ["Blackmagic Pocket 6K", "DJI Ronin RS3", "Aputure 600D", "Cyclo blanc", "Teradek Bolt 4K", "DaVinci Resolve Studio"]
  },
  {
    name: "Ménilmontant Visual Arts",
    description: "Graphiste + direction artistique pour pochettes d'album et covers singles. Style brut / industriel / collage. Livraison 48-72h.",
    address: "65 Rue de Ménilmontant",
    city: "Paris",
    price_per_hour: 38,
    latitude: 48.8672, longitude: 2.3916,  # Paris 20e
    rating: 4.7,
    category: "pochette",
    equipment: ["Adobe Creative Suite", "Procreate", "Wacom Cintiq 27", "Canon 5D Mark IV", "Imprimante pro A3"]
  },
  {
    name: "Belleville Beat School",
    description: "Cours de production et beatmaking (FL Studio, Ableton, MPC). Par session de 2h, débutant ou intermédiaire. Home studio équipé.",
    address: "12 Rue de Belleville",
    city: "Paris",
    price_per_hour: 25,
    latitude: 48.8722, longitude: 2.3830,  # Paris 20e
    rating: 4.9,
    category: "cours",
    equipment: ["FL Studio 21", "Ableton Live 11", "Akai MPK Mini", "Maschine MK3", "Adam T5V"]
  },
  {
    name: "Montreuil Sound Lab",
    description: "Grand studio porte de Montreuil : live room 40m², booth traitée, bonne chaîne de reprise batterie et guitare. Projet rock/jazz/rap live.",
    address: "3 Rue de Lagny",
    city: "Paris",
    price_per_hour: 38,
    latitude: 48.8478, longitude: 2.4074,  # Paris 20e
    rating: 4.4,
    category: "studio",
    equipment: ["Neumann U87", "Shure SM7B", "Royer R-121", "API 1608", "Pro Tools Ultimate", "Adam S3H"]
  }
]

studios_data.each_with_index do |data, i|
  slug  = data[:name].parameterize
  owner = marketplace_user!("studio_#{slug}@leplug.local")
  Studio.create!(data.merge(user: owner))
  puts "Created studio [#{i + 1}/10]: #{data[:name]} — €#{data[:price_per_hour]}/h"
end

# =============================================================================
# TALENTS — 8 talents parisiens
# =============================================================================

talents_data = [
  {
    name: "KAIS B.",
    specialty: "beatmaker",
    genres: ["Drill", "Trap", "Afro-Trap"],
    hourly_rate: 45,
    description: "Beatmaker drill français. 4 ans d'expérience, placements avec artistes labels indés. Style sombre, boom heavy, 808 lourdes.",
    city: "Paris",
    available: true
  },
  {
    name: "NINA F.",
    specialty: "mixeur",
    genres: ["Rap", "R&B", "Jazz fusion"],
    hourly_rate: 60,
    description: "Mixeuse freelance. Formée au CFPM. Expertise sur voix rappées et arrangements jazz. Prix dégressif pour packs 3+ titres.",
    city: "Paris",
    available: true
  },
  {
    name: "THÉO R.",
    specialty: "mastering",
    genres: ["Electro", "House", "Techno"],
    hourly_rate: 70,
    description: "Mastering ingénieur spécialisé en musique électronique. Chaîne analogique dédiée. Maste pour 3 labels techno parisiens.",
    city: "Paris",
    available: true
  },
  {
    name: "MAYA B.",
    specialty: "videaste",
    genres: ["Rap", "Afrobeats"],
    hourly_rate: 55,
    description: "Réalisatrice clips. Style visuel cru, références 2000s. 25+ clips réalisés. Tournage + montage + étalonnage.",
    city: "Paris",
    available: true
  },
  {
    name: "SOLÈNE D.",
    specialty: "graphiste",
    genres: ["All"],
    hourly_rate: 40,
    description: "Direction artistique + pochettes. Style brut, typographique, inspiration streetwear. Livraison 48h. Formats streaming & print.",
    city: "Paris",
    available: true
  },
  {
    name: "PROD.X",
    specialty: "prod",
    genres: ["Trap", "Drill", "Cloud rap"],
    hourly_rate: 80,
    description: "Producteur exécutif. Accompagne un artiste de A à Z sur un EP (direction artistique + composition + supervision mix/mastering).",
    city: "Paris",
    available: true
  },
  {
    name: "KARIM O.",
    specialty: "beatmaker",
    genres: ["Rap", "Boom bap"],
    hourly_rate: 35,
    description: "Beatmaker boom bap / lo-fi. Sampling vinyle, MPC Live 2. Parfait pour projets rap conscient et hip-hop old school.",
    city: "Paris",
    available: true
  },
  {
    name: "LUNA K.",
    specialty: "coach",
    genres: ["Rap", "R&B", "Pop"],
    hourly_rate: 50,
    description: "Coach vocal & technique. Diction, flow, respiration, placement micro. Sessions individuelles 1h ou 1h30 en studio.",
    city: "Paris",
    available: true
  }
]

talents_data.each_with_index do |data, i|
  slug  = data[:name].parameterize
  owner = marketplace_user!("talent_#{slug}@leplug.local")
  Talent.create!(data.merge(user: owner))
  puts "Created talent [#{i + 1}/8]: #{data[:name]} — €#{data[:hourly_rate]}/h · #{data[:specialty]}"
end

puts "\n--- Marketplace seed complete: #{Studio.count} studios, #{Talent.count} talents. ---"
