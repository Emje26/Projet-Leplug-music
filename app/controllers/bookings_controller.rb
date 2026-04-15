class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: :show

  def index
    @bookings = current_user.bookings.includes(:bookable).order(date: :desc, created_at: :desc)
  end

  def new
    @bookable = resolve_bookable
    unless @bookable
      redirect_to search_path, alert: "Bookable introuvable." and return
    end
    @booking = Booking.new(
      bookable: @bookable,
      user:     current_user,
      date:     Date.today + 2,
      duration_hours: 2
    )
  end

  def create
    @bookable = resolve_bookable(params.dig(:booking, :bookable_type), params.dig(:booking, :bookable_id))
    unless @bookable
      redirect_to search_path, alert: "Bookable introuvable." and return
    end

    @booking = current_user.bookings.new(booking_params.except(:bookable_type, :bookable_id))
    @booking.bookable = @bookable
    @booking.status   = "pending"

    if @booking.save
      redirect_to booking_path(@booking), notice: "Réservation enregistrée."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @bookable = @booking.bookable
  end

  private

  def set_booking
    @booking = current_user.bookings.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(
      :date, :start_time, :end_time, :duration_hours,
      :bookable_type, :bookable_id
    )
  end

  def resolve_bookable(type = nil, id = nil)
    type ||= params[:bookable_type]
    id   ||= params[:bookable_id]
    return nil if type.blank? || id.blank?

    case type
    when "Studio" then Studio.find_by(id: id)
    when "Talent" then Talent.find_by(id: id)
    end
  end
end
