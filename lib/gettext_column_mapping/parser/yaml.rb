require 'erb'
module GettextColumnMapping
  module Parser
    class Yaml
      def self.parse(path)
        YAML.load(ERB.new(IO.read(path))).result)
      end
    end
  end
end
