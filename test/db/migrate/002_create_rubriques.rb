# coding: utf-8
class CreateRubriques < ActiveRecord::Migration
  def self.up
    create_table :rubriques do |t|
      t.column :libelle, :string, :default => nil, :null => false
    end

    load_data :rubriques

  end

  def self.down
    drop_table :rubriques
  end
end
