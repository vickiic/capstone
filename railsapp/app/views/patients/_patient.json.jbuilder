json.extract! patient, :id, :name, :device, :age, :weight, :created_at, :updated_at, :pic, :height
json.url patient_url(patient, format: :json)
