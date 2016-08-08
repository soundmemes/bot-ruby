class Choice < Sequel::Model(:choices)
  many_to_one :user
  many_to_one :sound
end
