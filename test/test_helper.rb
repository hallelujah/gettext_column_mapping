# coding: utf-8
if ENV['GETTEXT']
  require 'gettext_helper'
else
  require 'fast_gettext_helper'
end

require 'models/utilisateur'
require 'models/categorie'
require 'models/rubrique'

require 'active_support/test_case'
require 'test/unit'
class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = File.expand_path("../db/fixtures",__FILE__)
  self.use_instantiated_fixtures = false
  self.use_transactional_fixtures = true
  set_fixture_class :categories => 'Categorie'
end


