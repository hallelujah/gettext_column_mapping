# coding: utf-8
class CreateUtilisateurs < ActiveRecord::Migration
  def self.up
    create_table :utilisateurs do |t|
      t.column :prenom, :string, :default => nil, :null => false
      t.column :nom, :string, :default => nil, :null => false
      t.column :age, :integer
      t.column :sexe, :string, :default => nil, :null => false
    end

  end

  def self.down
    drop_table :utilisateurs
  end
end
