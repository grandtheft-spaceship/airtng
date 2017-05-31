class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @vacation_property = VacationProperty.find(params[:reservation][:property_id])
    @reservation = @vacation_property.reservations.create(reservation_params)

    if @reservation.save
      flash[:notice] = "Sending your reservation request now."
      @reservation.notify_host
      redirect_to @vacation_property
    else
      flash[:danger] = @reservation.errors
    end
  end

# WEBHOOK FOR TWILIO INCOMING MESSAGE FROM HOST
  def accept_or_reject
    incoming = Santize.clean(params[:From]).gsub(/^\+\d/, '')
    sms_input = params[:Body].downcase
    begin
      @host = User.find_by(phone_number: incoming)
      @reservation = @host.pending_reservation

      if sms_input == "accept" || sms_input == "yes"
        @reservation.confirm!
      else
        @reservation.reject!
      end

      @host.check_for_reservations_pending

      sms_response = "You have successfully #{@reservation.status} the reservation."
      respond(sms_response)
    rescue
      sms_response = "Sorry, it looks like you don't have any reservations to respond to"
      respond(sms_response)
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # SEND AN SMS BACK TO THE SUBSCRIBER
  def respond(message)
    response = Twilio::TwiML::Response.new do |r|
      r.Message message
    end
    render text: response.text
  end

  # NEVER TRUST PARAMETERS FROM THE SCARY INTERNET, ONLY ALLOW THE WHITE LIST THROUGH
  def reservation_params
    params.require(:reservation).permit(:name, :phone_number, :message)
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reservation_params
    params.require(:reservation).permit(:name, :phone_number, :vacation_property_id, :user_id, :status)
  end
end
