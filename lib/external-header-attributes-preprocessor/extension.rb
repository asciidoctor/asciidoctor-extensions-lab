require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

require 'yaml'

# This extension allows you to load attributes from a config file. It piggybacks on the built-in docinfo functionality
# to resolve and read the config file. It looks for docinfo-config.yml by default, or <docname>-docinfo-config.yml if
# config=private The config file must be written in YAML. The attributes must be defined in a Hash at the path
# asciidoc.attributes in the data.
class ExternalHeaderAttributesPreprocessor < Asciidoctor::Extensions::Preprocessor
  def process document, reader
    document.delete_attribute 'docinfo' if (actual_docinfo = document.attr 'docinfo')
    document.set_attribute 'docinfo', (document.attr 'config', 'shared')
    unless (config_data = document.docinfo :config, '.yml').empty?
      config = ::YAML.load config_data
      if ::Hash === config['asciidoc'] && ::Hash === (attributes = config['asciidoc']['attributes'])
        attributes.each {|name, val| document.set_attribute name, val }
      end
    end
    actual_docinfo ? (document.set_attribute 'docinfo', actual_docinfo) : (document.delete_attribute 'docinfo')
    nil
  end
end
