Sequel.migration do
  change do
    create_table :tags do
      primary_key :id
      foreign_key :author_id, :users, null: true

      String :content, null: false, uniq: true
      DateTime :created_at

      index :content
    end
  end
end
