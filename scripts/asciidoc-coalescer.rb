# This script coalesces the AsciiDoc source into a single file by resolving all
# preprocessor directives, in particular include directives.

# TODO
# - add option to write cli attributes into header of document
# - add option to write output to file

require 'asciidoctor'
require 'optparse'

options = { attributes: [] }
OptionParser.new do |opts|
  opts.banner = 'Usage: ruby asciidoc-coalescer.rb [OPTIONS] FILE'
  opts.on('-a', '--attribute key[=value]', 'A document attribute to set in the form of key[=value]') do |a|
    options[:attributes] << a
  end
end.parse!

unless (source_file = ARGV.shift)
  warn 'Please specify an AsciiDoc source file to coalesce.'
  exit 1
end

doc = Asciidoctor.load_file source_file, safe: :safe, parse: false, attributes: options[:attributes]
lines = doc.reader.read.gsub(/^include::(?=.*\[\]$)/m, '\\include::')
puts lines
