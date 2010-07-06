# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gettext_column_mapping}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["hallelujah"]
  s.date = %q{2010-07-06}
  s.description = %q{Translate your database columns with gettext}
  s.email = %q{hery@rails-royce.org}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "examples/config/column_mapping.yml",
     "examples/config/gettext_db_extract.yml",
     "gettext_column_mapping.gemspec",
     "init.rb",
     "install.rb",
     "lib/gettext_column_mapping.rb",
     "lib/gettext_column_mapping/backends/base.rb",
     "lib/gettext_column_mapping/backends/gettext_activerecord.rb",
     "lib/gettext_column_mapping/backends/gettext_i18n_rails.rb",
     "lib/gettext_column_mapping/initializer.rb",
     "lib/gettext_column_mapping/mapper.rb",
     "lib/gettext_column_mapping/model_attributes_finder.rb",
     "lib/gettext_column_mapping/parent_level.rb",
     "lib/gettext_column_mapping/parent_level/attr_methods.rb",
     "lib/gettext_column_mapping/parser.rb",
     "lib/gettext_column_mapping/parser/yaml.rb",
     "lib/gettext_column_mapping/railtie.rb",
     "lib/gettext_column_mapping/tasks.rb",
     "tasks/gettext_column_mapping.rake",
     "test/.gitignore",
     "test/activerecord_test.rb",
     "test/config/column_mapping.yml",
     "test/config/database.yml",
     "test/config/parent_level_column_mapping.yml",
     "test/db/fixtures/categories.yml",
     "test/db/fixtures/rubriques.yml",
     "test/db/migrate/001_create_utilisateurs.rb",
     "test/db/migrate/002_create_rubriques.rb",
     "test/db/migrate/003_create_categories.rb",
     "test/extend_lib_path.rb",
     "test/fast_gettext_helper.rb",
     "test/gettext_column_mapping_test.rb",
     "test/gettext_helper.rb",
     "test/helper.rb",
     "test/log/.gitkeep",
     "test/mapper_test.rb",
     "test/models/categorie.rb",
     "test/models/rubrique.rb",
     "test/models/utilisateur.rb",
     "test/po/fr/gettext_column_mapping.po",
     "test/po/gettext_column_mapping.pot",
     "test/static/data.rb",
     "test/static/pluralization.rb",
     "test/test_helper.rb",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/hallelujah/gettext_column_mapping}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Translate your database columns with gettext}
  s.test_files = [
    "test/helper.rb",
     "test/static/data.rb",
     "test/static/pluralization.rb",
     "test/activerecord_test.rb",
     "test/mapper_test.rb",
     "test/fast_gettext_helper.rb",
     "test/gettext_column_mapping_test.rb",
     "test/extend_lib_path.rb",
     "test/gettext_helper.rb",
     "test/db/migrate/001_create_utilisateurs.rb",
     "test/db/migrate/003_create_categories.rb",
     "test/db/migrate/002_create_rubriques.rb",
     "test/models/categorie.rb",
     "test/models/rubrique.rb",
     "test/models/utilisateur.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

