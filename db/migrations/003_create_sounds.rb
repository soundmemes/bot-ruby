Sequel.migration do
  change do
    create_table :sounds do
      primary_key :id
      foreign_key :uploader_id, :users, null: true

      String :file_id
      String :title
      column :tag_ids, 'integer[]'

      DateTime :created_at
      DateTime :updated_at

      index :uploader_id
      index :file_id
      index :tag_ids
      index :created_at
    end
  end
end
