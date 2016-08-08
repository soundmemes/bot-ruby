Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      Integer :telegram_id, null: false, unique: true

      TrueClass :admin, default: false
      Integer :status, null: false, default: 0

      DateTime :created_at
      DateTime :updated_at

      index :telegram_id
    end
  end
end
