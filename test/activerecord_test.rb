# coding: utf-8
require 'test_helper'
require 'models/utilisateur'
require 'models/rubrique'
require 'models/categorie'
class ActiverecordTest < ActiveSupport::TestCase

  fixtures :categories,:rubriques

  def test_human_attribute_name
    GettextColumnMapping.locale = 'en'
    assert_equal 'First name', Utilisateur.human_attribute_name('prenom')
    assert_equal 'Last name', Utilisateur.human_attribute_name('nom')
    assert_equal 'Gender', Utilisateur.human_attribute_name('sexe')
    assert_equal 'Label', Rubrique.human_attribute_name('libelle')
    assert_equal 'Label', Categorie.human_attribute_name('libelle')
    GettextColumnMapping.locale = 'fr'
    assert_equal 'Prénom', Utilisateur.human_attribute_name('prenom')
    assert_equal 'Nom', Utilisateur.human_attribute_name('nom')
    assert_equal 'Sexe', Utilisateur.human_attribute_name('sexe')
    assert_equal 'Libellé', Rubrique.human_attribute_name('libelle')
    assert_equal 'Libellé', Categorie.human_attribute_name('libelle')
  end


  def test_parent_level
    cat = categories(:"event-wc")
    assert_equal 'Data|Model|Category|Event|Label|World Cup', cat.msgid_for_attribute('libelle')
    GettextColumnMapping.locale = 'en'
    assert_equal 'World Cup', cat.libelle
    GettextColumnMapping.locale = 'fr'
    assert_equal 'Evènement - Coupe du monde', cat.libelle
    # Sport Football
    cat = categories(:"sport-foot")
    assert_equal 'Data|Model|Category|Sport|Label|Football', cat.msgid_for_attribute('libelle')
    GettextColumnMapping.locale = 'en'
    assert_equal 'Football', cat.libelle
    GettextColumnMapping.locale = 'fr'
    assert_equal 'Sport - Football', cat.libelle

  end

end
