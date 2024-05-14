json.array!(@localidades) do |localidade|
  json.extract! localidade, :nome, :id
end

