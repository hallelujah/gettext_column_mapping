# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
%w{rails/activesupport rails/activerecord fast_gettext gettext_i18n_rails gettext_activerecord}.each do |p|
  dir = File.expand_path("../../../#{p}", __FILE__)
  if File.directory?(dir)
    $LOAD_PATH.unshift(File.join(dir,'lib'))
  end
end
