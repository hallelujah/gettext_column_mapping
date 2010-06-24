require 'helper'
require 'models/utilisateur'
class UtilisateurTest < Test::Unit::TestCase
  def test_column_names
    assert_equal 'Model|User', Utilisateur.to_s_with_gettext
    assert_equal 'Model|User|Gender', Utilisateur.gettext_translation_for_attribute_name('sexe')
    assert_equal 'Model|User|Last name', Utilisateur.gettext_translation_for_attribute_name('nom')
    assert_equal 'Model|User|First name', Utilisateur.gettext_translation_for_attribute_name('prenom')
    assert_equal 'Model|User|Age', Utilisateur.gettext_translation_for_attribute_name('age')
  end

  def test_translation
    FastGettext.locale = 'en'
    assert_equal 'User', Utilisateur.human_name
    assert_equal 'Apples', ns_("Toto|Apple","Toto|Apples",5)
    assert_equal 'Apple', ns_("Toto|Apple","Toto|Apples",1)
  end
end

