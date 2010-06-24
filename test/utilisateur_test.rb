require 'helper'
require 'models/utilisateur'
class UtilisateurTest < Test::Unit::TestCase
  def test_column_names
    assert_equal 'Gender', Utilisateur.human_attribute_name('sexe')
    assert_equal 'Model|User', Utilisateur.to_s_with_gettext
  end
end

