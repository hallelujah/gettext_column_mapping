# coding: utf-8
require 'test_helper'
class UtilisateurTest < ActiveSupport::TestCase
  fixtures :categories, :rubriques

  class NotMapped < ActiveRecord::Base; end

  def test_to_s_with_gettext
    assert_equal 'Model|User', Utilisateur.to_s_with_gettext
  end

  def test_translate_key
    assert GettextColumnMapping.mapper.translate_key?(Utilisateur,'sexe')
    assert GettextColumnMapping.mapper.translate_key?(Utilisateur,'nom')
    assert GettextColumnMapping.mapper.translate_key?(Utilisateur,'prenom')
  end

  def column_translation_for_attribute
    assert_equal 'Model|User|Gender', GettextColumnMapping.mapper.column_translation_for_attribute(Utilisateur,'sexe')
    assert_equal 'Model|User|First name', GettextColumnMapping.mapper.column_translation_for_attribute(Utilisateur,'prenom')
    assert_equal 'Model|User|Last name', GettextColumnMapping.mapper.column_translation_for_attribute(Utilisateur,'nom')
    assert_equal 'Model|User|Age', GettextColumnMapping.mapper.column_translation_for_attribute(Utilisateur,'age')
  end

  def test_translate_class_name
    assert ! GettextColumnMapping.mapper.translate_class_name?(NotMapped)
    assert GettextColumnMapping.mapper.translate_class_name?(Utilisateur)
  end

  def test_map_attribute
    assert 'Label', GettextColumnMapping.mapper.map_attribute(NotMapped,'label')
    assert 'Label', GettextColumnMapping.mapper.map_attribute(Categorie,'label')
  end

  def test_translation
    GettextColumnMapping.locale = 'en'
    assert_equal 'User', Utilisateur.human_name
    assert_equal 'Apples', ns_("Fruits|Apple","Apples",5)
    assert_equal 'Apple', ns_("Fruits|Apple","Apples",1)
    GettextColumnMapping.locale = 'fr'
    assert_equal 'Utilisateur', Utilisateur.human_name
    assert_equal 'Pommes', ns_("Fruits|Apple","Apples",5)
    assert_equal 'Pomme', ns_("Fruits|Apple","Apples",1)
  end

end

