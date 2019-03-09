json.extract! heartrate, :id, :device, :value, :time, :symptom, :created_at, :updated_at
json.url heartrate_url(heartrate, format: :json)
