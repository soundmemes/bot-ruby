Sequel.migration do
  change do
    create_table :choices do
      primary_key :id

      foreign_key :user_id, :users, null: false
      foreign_key :sound_id, :sounds, null: false
      String :query, null: true

      DateTime :created_at

      index :sound_id
      index :query
      index :created_at
    end
  end
end
