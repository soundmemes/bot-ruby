Sequel.migration do
  change do
    add_column :users, :saved_sound_ids, 'integer[]'
  end
end
