class SearchController < ApplicationController
  before_action :authenticate_user!

  CATEGORIES = [
    { slug: "studio",    label: "STUDIOS"    },
    { slug: "beatmaker", label: "BEATMAKERS" },
    { slug: "mixage",    label: "MIXAGE"     },
    { slug: "mastering", label: "MASTERING"  },
    { slug: "clip",      label: "VIDÉO CLIP" },
    { slug: "pochette",  label: "POCHETTE"   },
    { slug: "prod",      label: "PROD"       },
    { slug: "cours",     label: "COURS"      }
  ].freeze

  def index
    @categories = CATEGORIES

    # Quick "nearby" row = a short mix of studios + talents.
    @nearby_studios = Studio.where(city: "Paris").order(rating: :desc).limit(6)
    @nearby_talents = Talent.available.where(city: "Paris").order(rating: :desc).limit(6)

    # Trades grid (2-col "Explore by métier")
    @trades = CATEGORIES
  end

  def results
    @query    = params[:q].to_s.strip
    @category = params[:category].to_s.strip
    @city     = params[:city].to_s.strip

    @studios = Studio.search(@query).with_category(studio_category).in_city(@city).order(rating: :desc)
    @talents = Talent.search(@query).with_specialty(talent_specialty).in_city(@city).available.order(rating: :desc)

    @total = @studios.size + @talents.size
  end

  private

  # Search category slugs partially overlap between Studio.category
  # and Talent.specialty. Route them correctly.
  def studio_category
    return nil if @category.blank?
    Studio::CATEGORIES.include?(@category) ? @category : nil
  end

  def talent_specialty
    return nil if @category.blank?
    Talent::SPECIALTIES.include?(@category) ? @category : nil
  end
end
