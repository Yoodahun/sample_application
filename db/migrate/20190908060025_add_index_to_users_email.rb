class AddIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def change
    #tablename, column name, option
    add_index :users, :email, unique: true
  end
end
