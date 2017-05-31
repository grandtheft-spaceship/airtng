json.extract! user, :id, :email, :name, :country_code, :phone_number, :password, :created_at, :updated_at
json.url user_url(user, format: :json)
