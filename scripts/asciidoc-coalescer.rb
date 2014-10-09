# This script coalesces the AsciiDoc source into a single file by resolving all
# preprocessor directives, in particular include directives.

require 'asciidoctor'

source_file = ARGV[0]
doc = Asciidoctor.load_file source_file, safe: :safe, parse: false
puts doc.reader.read
