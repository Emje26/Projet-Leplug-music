puts "Seeding the database..."

user = User.find_or_create_by!(email: 'jo_sample@example.com') do |u|
  puts "Creating initial User: jo_sample@example.com"
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

puts "Seeding the database..."

puts "Seeding the database..."

def extract_time_minutes(str)
  return nil if str.nil?
  str.to_s[/\d+/].to_i
end

def format_description(data)
  <<~DESC
    Nutritional info:
    #{data[:nutrients]}

    Ingredients:
    #{data[:ingredients]}

    Steps:
    #{data[:steps]}
  DESC
end

recipes_source_data = [
  {
    title: 'Morning Chia Seed Bowl with 5 Plants',
    prep_time: '5 min',
    cook_time_str: '0 min',
    nutrients: 'Energy: 350 kcal | Protein: 12g | Fiber: 15g | Fats: 18g (Omega-3)',
    ingredients: "3 tbsp chia seeds\n1 cup almond milk\n1/2 mashed banana (plant 1)\n1 tsp cinnamon (plant 2)\n1/2 cup raspberries (plant 3)\n1 tbsp pecans (plant 4)\n1 tbsp ground flaxseed (plant 5)",
    steps: "Mix all ingredients except raspberries in a jar.\nRefrigerate for at least 4 hours.\nTop with raspberries before serving.",
    saved: true
  },
  {
    title: 'Black Bean, Avocado & Roasted Sweet Potato Salad',
    prep_time: '20 min',
    cook_time_str: '25 min',
    nutrients: 'Energy: 520 kcal | Protein: 25g | Fiber: 18g | Healthy Fats: 28g',
    ingredients: "1 medium sweet potato, roasted and diced (plant 1)\n1 cup black beans, rinsed (plant 2)\n1/2 avocado, sliced (plant 3)\n1/4 cup chopped fresh cilantro (plant 4)\nJuice of half a lime\n1 tbsp extra virgin olive oil\nA pinch of cumin and cayenne pepper (plants 5, 6)",
    steps: "Roast the sweet potato (can be done ahead).\nIn a bowl, combine sweet potato, black beans, and cilantro.\nSeason with lime juice, olive oil, cumin, and cayenne.\nTop with avocado and serve.",
    saved: true
  },
  {
    title: 'Red Lentil & Cauliflower Curry (30-Plants Focus)',
    prep_time: '15 min',
    cook_time_str: '30 min',
    nutrients: 'Energy: 480 kcal | Protein: 22g | Fiber: 17g | Carbs: 60g',
    ingredients: "1 cup red lentils (plant 1)\n3 cups vegetable broth\n1 head cauliflower (plant 2)\n1 chopped onion (plant 3)\n3 garlic cloves (plant 4)\nA nub of fresh ginger (plant 5)\n1 can crushed tomatoes (plant 6)\n1 tbsp curry paste\n1 tsp turmeric (plant 7)",
    steps: "Sauté onion, garlic, and ginger in olive oil.\nAdd curry paste and turmeric.\nAdd lentils, cauliflower, tomatoes, and broth. Bring to a boil.\nSimmer for 30 minutes. Season and serve.",
    saved: true
  },
  {
    title: 'Protein Toast with Homemade Hummus & Summer Veggies',
    prep_time: '10 min',
    cook_time_str: '0 min',
    nutrients: 'Energy: 410 kcal | Protein: 18g | Fiber: 10g | Fats: 20g',
    ingredients: "2 slices gluten-free whole-grain bread (plant 1)\n1/4 cup chickpeas (plant 2)\n1 tsp tahini\nLemon juice\n1 diced tomato (plant 3)\nCucumber slices (plant 4)\nA pinch of oregano and basil (plants 5, 6)",
    steps: "Toast the bread.\nMash chickpeas with tahini and lemon to make quick hummus.\nSpread on toast and top with tomato and cucumber.",
    saved: false
  },
  {
    title: 'Green Immunity Smoothie with Berries & Spinach',
    prep_time: '5 min',
    cook_time_str: '0 min',
    nutrients: 'Energy: 310 kcal | Protein: 8g | Fiber: 12g | Carbs: 50g',
    ingredients: "1/2 cup oat milk (plant 1)\n1 cup fresh spinach (plant 2)\n1/2 cup blueberries (plant 3)\n1/2 green apple (plant 4)\n1 tsp spirulina\n1 tbsp pumpkin seeds (plant 5)",
    steps: "Add all ingredients to a blender.\nBlend until smooth.",
    saved: true
  },
  {
    title: 'Carrot & Ginger Soup with Spices',
    prep_time: '15 min',
    cook_time_str: '20 min',
    nutrients: 'Energy: 250 kcal | Protein: 6g | Fiber: 11g | Fats: 12g',
    ingredients: "5 medium carrots (plant 1)\n1 chopped onion\n2 cm fresh ginger, chopped\n4 cups vegetable broth\n1 tsp turmeric\n1 tsp smoked paprika (plant 2)",
    steps: "Sauté onion in olive oil.\nAdd carrots, ginger, and spices; cook 5 min.\nAdd broth and cook until carrots are tender.\nBlend until smooth.",
    saved: false
  },
  {
    title: 'Stir-Fried Brown Rice with Tofu & Tamari',
    prep_time: '10 min',
    cook_time_str: '15 min',
    nutrients: 'Energy: 550 kcal | Protein: 35g | Fiber: 10g | Carbs: 70g',
    ingredients: "1 block firm tofu (plant 1)\n1 cup cooked brown rice (plant 2)\n1/2 red bell pepper (plant 3)\n1/2 broccoli (plant 4)\n2 tbsp tamari\n1 tbsp sesame oil (plant 5)\nA handful of chopped peanuts (plant 6)",
    steps: "Brown tofu in sesame oil.\nAdd pepper and broccoli; cook until tender.\nAdd rice and tamari; stir.\nServe topped with peanuts.",
    saved: true
  },
  {
    title: 'Buckwheat Pancakes with Apple & Walnuts',
    prep_time: '10 min',
    cook_time_str: '10 min',
    nutrients: 'Energy: 430 kcal | Protein: 10g | Fiber: 8g | Fats: 18g',
    ingredients: "1 cup buckwheat flour (plant 1)\n1 cup plant milk (oat)\n1 egg\n1 tsp baking powder\n1 grated apple (plant 2)\n1/4 cup chopped walnuts (plant 3)\nA pinch of nutmeg (plant 4)",
    steps: "Mix dry ingredients.\nIn another bowl, mix milk, egg, and grated apple.\nCombine mixtures and fold in walnuts.\nCook pancakes in a pan.",
    saved: false
  },
  {
    title: 'Fish en Papillote with Mediterranean Vegetables',
    prep_time: '10 min',
    cook_time_str: '20 min',
    nutrients: 'Energy: 400 kcal | Protein: 40g | Fiber: 7g | Fats: 20g',
    ingredients: "1 white fish fillet\n1/2 zucchini (plant 1)\n1/2 yellow bell pepper (plant 2)\n2 tbsp sun-dried tomatoes (plant 3)\n1 tbsp black olives (plant 4)\n1 minced garlic clove\nA drizzle of extra virgin olive oil\nThyme & rosemary (plants 5, 6)",
    steps: "Preheat oven to 200°C. Place fish on parchment paper.\nArrange vegetables, olives, and tomatoes around it.\nDrizzle with olive oil and sprinkle herbs and garlic.\nClose parchment and bake 20 minutes.",
    saved: true
  },
  {
    title: 'Whole-Wheat Pita Filled with Marinated Tempeh',
    prep_time: '10 min',
    cook_time_str: '10 min',
    nutrients: 'Energy: 500 kcal | Protein: 32g | Fiber: 12g | Carbs: 55g',
    ingredients: "1 whole-wheat pita (plant 1)\n1/2 block tempeh (plant 2)\n2 tbsp soy sauce or tamari\n1 tsp maple syrup\n1 cup shredded red cabbage (plant 3)\n1/4 cup fresh parsley (plant 4)",
    steps: "Marinate tempeh in tamari and maple syrup.\nPan-fry until golden.\nFill pita with tempeh, red cabbage, and parsley.",
    saved: false
  }
]

recipes_source_data.each do |data|
  Recipe.create!(
    user:        user,
    title:       data[:title],
    description: format_description(data),
    prep_time:   extract_time_minutes(data[:prep_time]),
    cook_time:   extract_time_minutes(data[:cook_time_str]),
    servings:    4 # Default value
  )
  puts "Created recipe: #{data[:title]}"
end

puts "--- Seeding complete. Created #{Recipe.count} recipes. ---"
puts "Seeding complete."

# =============================================================================
# LE PLUG — MARKETPLACE SEEDS (studios + talents)
# =============================================================================
# Idempotent: wipes and rebuilds the marketplace tables on every run so the
# seeds stay in sync with the fixture data below. Does NOT touch anything
# outside the marketplace (users, recipes, profiles, etc.).
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
