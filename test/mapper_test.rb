require 'helper'
require 'models/utilisateur'
class UtilisateurTest < Test::Unit::TestCase
  def test_to_s_with_gettext
    assert_equal 'Model|User', Utilisateur.to_s_with_gettext
  end

  def test_has_translation_key
    assert GettextColumnMapping.mapper.has_translation_key?(Utilisateur,'sexe')
    assert GettextColumnMapping.mapper.has_translation_key?(Utilisateur,'nom')
    assert GettextColumnMapping.mapper.has_translation_key?(Utilisateur,'prenom')
  end

  def column_translation_for_attribute
    assert_equal 'Model|User|Gender', GettextColumnMapping.mapper.column_translation_for_attribute(Utilisateur,'sexe')
    assert_equal 'Model|User|First name', GettextColumnMapping.mapper.column_translation_for_attribute(Utilisateur,'prenom')
    assert_equal 'Model|User|Last name', GettextColumnMapping.mapper.column_translation_for_attribute(Utilisateur,'nom')
    assert_equal 'Model|User|Age', GettextColumnMapping.mapper.column_translation_for_attribute(Utilisateur,'age')
  end

  def test_translation
    FastGettext.locale = 'en'
    assert_equal 'User', Utilisateur.human_name
    assert_equal 'Apples', ns_("Toto|Apple","Toto|Apples",5)
    assert_equal 'Apple', ns_("Toto|Apple","Toto|Apples",1)
  end

end
