# coding: utf-8
require 'test_helper'
require 'models/utilisateur'
require 'models/rubrique'
require 'models/categorie'
class ActiverecordTest < Test::Unit::TestCase

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

  end

end
