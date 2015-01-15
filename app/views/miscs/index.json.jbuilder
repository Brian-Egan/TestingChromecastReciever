json.array!(@miscs) do |misc|
  json.extract! misc, :id, :babble
  json.url misc_url(misc, format: :json)
end
