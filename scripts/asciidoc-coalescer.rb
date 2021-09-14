#!/usr/bin/env ruby

# This script coalesces the AsciiDoc content from a document master into a
# single output file. It does so by resolving all preprocessor directives in
# the document, and in any files which are included. The resolving of include
# directives is likely of most interest to users of this script.
#
# This script works by using Asciidoctor's PreprocessorReader to read and
# resolve all the lines in the specified input file. The script then writes the
# result to the output.
#
# The script only recognizes attributes passed in as options or those defined
# in the document header. It does not currently process attributes defined in
# other, arbitrary locations within the document.
#
# You can find a similar extension written against AsciidoctorJ here:
# https://github.com/hibernate/hibernate-asciidoctor-extensions/blob/master/src/main/java/org/hibernate/infra/asciidoctor/extensions/savepreprocessed/SavePreprocessedOutputPreprocessor.java

# TODO
# - add cli option to write attributes passed to cli to header of document
# - wrap in a custom converter so it can be used as an extension

require 'asciidoctor'
require 'optparse'


options = { attributes: [], output: '-', include_only: false }
OptionParser.new do |opts|
  opts.banner = 'Usage: ruby asciidoc-coalescer.rb [OPTIONS] FILE'
  opts.on('-a', '--attribute key[=value]', 'A document attribute to set in the form of key[=value]') do |a|
    options[:attributes] << a
  end
  opts.on('-o', '--output FILE', 'Write output to FILE instead of stdout.') do |o|
    options[:output] = o
  end
  opts.on('-i', '--include-only', 'Process include:: directives only') do |i|
    options[:include_only] = i
  end
end.parse!

unless (source_file = ARGV.shift)
  warn 'Please specify an AsciiDoc source file to coalesce.'
  exit 1
end

unless (output_file = options[:output]) == '-'
  if (output_file = File.expand_path output_file) == (File.expand_path source_file)
    warn 'Source and output cannot be the same file.'
    exit 1
  end
end

# NOTE first, resolve attributes defined at the end of the document header
# QUESTION can we do this in a single load?
doc = Asciidoctor.load_file source_file, safe: :unsafe, header_only: true, attributes: options[:attributes]
# NOTE quick and dirty way to get the attributes set or unset by the document header
header_attr_names = (doc.instance_variable_get :@attributes_modified).to_a
header_attr_names.each {|k| doc.attributes[%(#{k}!)] = '' unless doc.attr? k }

## monkey patch lib/asciidoctor/reader.rb#PreprocessorReader.process_line to only process unescaped preprocessor directive "include::"
if options[:include_only]
  module Asciidoctor
    class PreprocessorReader
      ## adapted from https://github.com/asciidoctor/asciidoctor/blob/1b6da4f2d883e61d2e785ff5dd986c8e2ce0c988/lib/asciidoctor/reader.rb#L802
      def process_line line
        return line unless @process_lines

        if line.empty?
          @look_ahead += 1
          return line
        end

        # NOTE highly optimized
        if (line.end_with? ']') && !(line.start_with? '[') && (line.include? '::')
          if (line.start_with? 'inc') && IncludeDirectiveRx =~ line
            # QUESTION should we strip whitespace from raw attributes in Substitutors#parse_attributes? (check perf)
            if preprocess_include_directive $2, $3
              # add include directive as comment
              unshift '// **preprocessed** ' + line
              # peek again since the content has changed
              return nil
            else
              # the line was not a valid include line and is unchanged
              # mark it as visited and return it
              @look_ahead += 1
              return line
            end
          else
            # NOTE optimization to inline super
            @look_ahead += 1
            return line
          end
        else
          # NOTE optimization to inline super
          @look_ahead += 1
          return line
        end
      end # def process_line
    end # class PreprocessorReader
  end # module Asciidoctor
end # options[:include_only]

doc = Asciidoctor.load_file source_file, safe: :unsafe, parse: false, attributes: doc.attributes
lines = doc.reader.read

if output_file == '-'
  puts lines
else
  File.open(output_file, 'w') {|f| f.write lines }
end
