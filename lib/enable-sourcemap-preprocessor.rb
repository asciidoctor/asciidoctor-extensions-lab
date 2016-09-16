require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

# A preprocessor that enables the sourcemap feature if not already enabled via
# the API. Useful to use in combination with other extensions that rely on the
# source location information.
Asciidoctor::Extensions.register do
  preprocessor do
    process do |doc, reader|
      doc.instance_variable_set :@sourcemap, true
      nil
    end
  end
end
