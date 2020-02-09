class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true
      # Create user_id column automatically using index and foreign key

      t.timestamps
      # Create created_at and updated_at columns

    end
    add_index :microposts, [:user_id, :created_at];
    #Create multiple key index.
  end
end
