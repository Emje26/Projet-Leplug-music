# Prompt pour Générer le Template KITCHEN_GURU

Copie ce prompt et colle-le dans une autre IA pour qu'elle génère automatiquement la même structure de projet.

---

## PROMPT À COPIER :

```
Crée un projet Ruby on Rails 7.1 complet appelé "KITCHEN_GURU" - une application de planification de repas avec assistant IA nutritionniste.

## SPÉCIFICATIONS TECHNIQUES

### Stack Technique
- Ruby 3.3.5
- Rails 7.1.6
- PostgreSQL
- Bootstrap 5.3
- Hotwire (Turbo + Stimulus)
- Devise pour l'authentification
- Simple Form
- Importmap pour JavaScript
- Font Awesome 6.x
- ruby_llm gem pour intégration IA

### Structure de Base de Données

**Table users:**
- email (string, unique, not null)
- encrypted_password (string, not null)
- reset_password_token (string)
- reset_password_sent_at (datetime)
- remember_created_at (datetime)
- gender (string)
- age (integer)
- physical_activity_profile (string)

**Table recipes:**
- user_id (bigint, foreign key)
- title (string)
- description (text)
- prep_time (integer) - minutes
- cook_time (integer) - minutes
- servings (integer)
- calories (integer) - kcal par portion
- proteins (decimal 6,2) - grammes
- carbs (decimal 6,2) - grammes
- fats (decimal 6,2) - grammes
- fiber (decimal 6,2) - grammes
- difficulty (string) - enum: facile, moyen, difficile
- image_url (string)
- estimated_cost (decimal 6,2) - euros
- category (string) - enum: petit-déjeuner, déjeuner, dîner, snack
- cuisine_type (string)
- is_vegetarian (boolean, default: false)
- is_vegan (boolean, default: false)
- is_gluten_free (boolean, default: false)
- image_data (text) - base64

**Table profiles:**
- user_id (bigint, foreign key)
- name (string)
- bio (text)

**Table user_preferences:**
- age (integer)
- gender (string)
- activity_level (string)
- weekly_budget_max (decimal)
- max_prep_time_minutes (integer)
- allergies (text)

### Routes Principales

```ruby
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "home#index"

  # Assistant chatbot IA
  get  "assistant",        to: "assistant#show",  as: :assistant
  post "assistant/talk",   to: "assistant#talk",  as: :assistant_talk
  post "assistant/reset",  to: "assistant#reset", as: :reset_chat
  post "assistant/save",   to: "assistant#save",  as: :assistant_save

  resource :profile, only: [:show, :edit, :update]
  get 'who_you_are', to: 'profiles#edit', as: :who_you_are

  post 'meal_plans/generate', to: 'meal_plans#generate', as: :meal_plans_generate

  resources :recipes, only: [:index, :show, :destroy, :new, :create]

  get "planner", to: "pages#planner"
  get "up" => "rails/health#show", as: :rails_health_check
end
```

### Modèles

**Recipe Model:**
```ruby
class Recipe < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { minimum: 3, maximum: 200 }
  validates :prep_time, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :cook_time, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :servings, numericality: { greater_than: 0 }, allow_nil: true
  validates :calories, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :difficulty, inclusion: { in: %w[facile moyen difficile] }, allow_nil: true
  validates :category, inclusion: { in: %w[petit-déjeuner déjeuner dîner snack] }, allow_nil: true

  scope :by_category, ->(cat) { where(category: cat) }
  scope :vegetarian, -> { where(is_vegetarian: true) }
  scope :vegan, -> { where(is_vegan: true) }
  scope :gluten_free, -> { where(is_gluten_free: true) }
  scope :quick_recipes, -> { where("prep_time + cook_time <= ?", 30) }

  def total_time
    (prep_time || 0) + (cook_time || 0)
  end

  def macros_summary
    { calories: calories, proteins: proteins, carbs: carbs, fats: fats, fiber: fiber }
  end
end
```

**User Model:**
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :meal_plans, dependent: :destroy
end
```

### Controllers

**AssistantController** - Chatbot IA nutritionniste:
- Action `show`: Affiche l'interface de chat
- Action `talk`: Envoie un message à l'IA et reçoit une réponse
- Action `reset`: Réinitialise la conversation
- Action `save`: Sauvegarde une recette générée par l'IA

L'assistant utilise un system prompt "KitchenGuru" spécialisé en:
- Santé intestinale et cuisine anti-inflammatoire (principes ZOE Health)
- Diversité: 30+ plantes différentes par semaine
- Qualité des graisses: huile d'olive, avocat, noix
- Éviter les aliments ultra-transformés

### Services

**MenuGeneratorService** - Génération de menus avec Gemini API:
- Génère des plans de repas hebdomadaires (7 jours)
- 3 repas par jour: Petit-déjeuner, Déjeuner, Dîner
- Basé sur les préférences utilisateur
- Retourne du JSON structuré

### Configuration IA

**ruby_llm.rb initializer:**
```ruby
RubyLLM.configure do |config|
  config.openai_api_key  = ENV["GITHUB_TOKEN"]
  config.openai_api_base = "https://models.inference.ai.azure.com"
end
```

**Variables d'environnement requises:**
- GEMINI_API_KEY - Pour MenuGeneratorService
- GITHUB_TOKEN - Pour RubyLLM (Azure OpenAI)

### Gemfile Complet

```ruby
source "https://rubygems.org"

ruby "3.3.5"

gem "rails", "~> 7.1.6"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Authentication
gem "devise"

# AI Integration
gem "ruby_llm", "~> 1.2.0"

# UI/Frontend
gem "bootstrap", "~> 5.3"
gem "autoprefixer-rails"
gem "font-awesome-sass", "~> 6.1"
gem "simple_form", github: "heartcombo/simple_form"
gem "sassc-rails"

group :development, :test do
  gem "dotenv-rails"
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
```

### Structure des Dossiers

```
app/
├── assets/
│   ├── config/
│   ├── images/
│   └── stylesheets/
├── channels/application_cable/
├── controllers/
│   ├── application_controller.rb
│   ├── assistant_controller.rb
│   ├── home_controller.rb
│   ├── meal_plans_controller.rb
│   ├── recipes_controller.rb
│   ├── concerns/
│   └── users/
├── helpers/
├── javascript/
│   ├── application.js
│   └── controllers/
├── jobs/
├── mailers/
├── models/
│   ├── application_record.rb
│   ├── recipe.rb
│   ├── user.rb
│   └── concerns/
├── services/
│   └── menu_generator_service.rb
└── views/
    ├── assistant/
    ├── devise/
    ├── home/
    ├── layouts/
    ├── profiles/
    ├── recipes/
    └── shared/
config/
├── initializers/
│   ├── devise.rb
│   ├── ruby_llm.rb
│   ├── simple_form.rb
│   └── simple_form_bootstrap.rb
└── locales/
    ├── devise.en.yml
    ├── en.yml
    └── simple_form.en.yml
db/
├── migrate/
├── schema.rb
└── seeds.rb
```

### Instructions de Génération

1. Crée le projet Rails avec PostgreSQL
2. Configure Devise avec le modèle User personnalisé
3. Crée les migrations pour toutes les tables
4. Génère les contrôleurs et les vues
5. Configure Bootstrap 5 avec Simple Form
6. Ajoute le service MenuGeneratorService
7. Configure l'assistant IA avec le system prompt ZOE Health
8. Crée les fichiers de configuration pour les APIs IA
9. Génère un Dockerfile pour le déploiement

Génère TOUS les fichiers nécessaires avec leur contenu complet, prêts à l'emploi.
```

---

## UTILISATION

1. Copie le contenu entre les balises ``` ci-dessus
2. Colle-le dans ChatGPT, Claude, ou une autre IA
3. L'IA générera tous les fichiers du projet

## NOTES

- Les clés API doivent être configurées via variables d'environnement
- Le projet utilise PostgreSQL (pas SQLite)
- Bootstrap 5.3 est intégré avec Simple Form
- L'assistant IA utilise les principes nutritionnels ZOE Health
