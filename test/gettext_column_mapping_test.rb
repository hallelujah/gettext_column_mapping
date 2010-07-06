# coding: utf-8
require 'test_helper'
class GettextColumnMappingTest < ActiveSupport::TestCase

  def test_config
    assert_instance_of ActiveSupport::OrderedOptions, GettextColumnMapping.config
    assert_instance_of GettextColumnMapping::Mapper, GettextColumnMapping.mapper
    assert_equal :yaml, GettextColumnMapping.config.config_parser
    if ENV['GETTEXT']
      assert_equal :gettext_activerecord, GettextColumnMapping.config.backend
    else
      assert_equal :gettext_i18n_rails, GettextColumnMapping.config.backend
    end
    assert_not_nil GettextColumnMapping.config.backend_class
    assert_equal "Model", GettextColumnMapping.config.model_prefix
    assert_equal "Data", GettextColumnMapping.config.data_prefix

    GettextColumnMapping.config.config_file = File.join($gettext_column_mapping_root, 'config/column_mapping.yml')
    assert_not_nil GettextColumnMapping.config.config_file

    GettextColumnMapping::Initializer.run
  end

end
