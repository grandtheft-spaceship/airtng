json.extract! reservation, :id, :name, :phone_number, :vacation_property_id, :user_id, :status, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
