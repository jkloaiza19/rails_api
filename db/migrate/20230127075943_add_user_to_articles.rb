# This class adds a column to the articles table called user_id, which is an integer.
class AddUserToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :user_id, :int
  end
end
