class Reservation < ApplicationRecord
  belongs_to :vacation_property
  belongs_to :user

  validates :name, presence: true
  validates :phone_number, presence: true

  enum status: [:pending, :confirmed, :rejected]

  def notify_host(force=false)
    @host = User.find(self.vacation_property[:user_id])

    #DON'T SEND THE MESSAGE IF WE HAVE MORE THAN ONE OR WE AREN'T BEING FORCED
    if @host.pending_reservations.length > 1 or !force
      return
    else
      message = "You have a new reservation request from #{self.name} for #{self.vacation_property.description}:

      '#{self.message}'

      Reply [accept] or [reject]."

      @host.send_message_via_sms(message)
    end
  end

  def confirm!
    self.status = "confirmed"
    self.save!
  end

  def reject!
    self.status = "rejected"
    self.save!
  end

  def notify_guest
    @guest = User.find_by(phone_number: self.phone_number)

    if self.status_changed? && (self.status == "confirmed" || self.status == "rejected")
      message = "Your recent request to stay at #{self.vacation_property.description} was #{self.status}."
      @guest.send_message_via_sms(message)
    end
  end

end
