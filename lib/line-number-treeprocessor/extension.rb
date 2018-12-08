require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# A treeprocessor extension that provides a role with the 
# line numbers as "data-line-###" where ### is the line number
# Provides the same value as a "data-line" attribute and also
# the filename being processed using the "data-file" attribute.
# This requires the sourcemap preprocessor extension to be used
# or the sourcemap option given to the Asciidoctor command.
# 
# These appear to be valid ways to add metadata to html5 tags.
# https://www.w3schools.com/tags/att_global_data.asp

class LineNumberTreeprocessor < Extensions::Treeprocessor

    def process document
        return unless document.blocks?
        if (document.attr? 'apply-data-line') 
            process_blocks document
        end
    end

    def process_blocks document
        (document.find_by).each do |block|
            if !block.lineno.nil?
                block.set_attr 'data-file', block.file
                block.set_attr 'data-line', block.lineno.to_s
                # this is not semantically righteous
                block.add_role 'data-line-' + block.lineno.to_s
            end
        end
    end
    
end
