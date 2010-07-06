# coding: utf-8
class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :libelle, :string, :default => nil, :null => false
      t.column :rubrique_id, :integer, :default => nil, :null => false
    end

    load_data(:categories)

  end

  def self.down
    drop_table :categories
  end
end
