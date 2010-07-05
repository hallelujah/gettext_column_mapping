# coding: utf-8
class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :libelle, :string, :default => nil, :null => false
      t.column :rubrique_id, :integer, :default => nil, :null => false
    end

    require 'models/categorie'
    Categorie.reset_column_information
    Categorie.create!([
      {:libelle => "Football", :rubrique_id => 1},
      {:libelle => "Coupe du monde", :rubrique_id => 1},
      {:libelle => "Football", :rubrique_id => 2},
      {:libelle => "Coupe du monde", :rubrique_id => 2}
    ])

  end

  def self.down
    drop_table :categories
  end
end
