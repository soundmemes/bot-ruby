class Tag < Sequel::Model(:tags)
  plugin :pg_array_associations
  many_to_pg_array :sounds, uniq: true
  many_to_one :author, class: :User
end
