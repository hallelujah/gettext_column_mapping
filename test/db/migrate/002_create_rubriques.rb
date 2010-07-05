# coding: utf-8
class CreateRubriques < ActiveRecord::Migration
  def self.up
    create_table :rubriques do |t|
      t.column :libelle, :string, :default => nil, :null => false
    end

    require 'models/rubrique'

    Rubrique.reset_column_information
    Rubrique.create!([
      {:libelle => "Sport"},
      {:libelle => "Evènements"},
    ])

  end

  def self.down
    drop_table :rubriques
  end
end
