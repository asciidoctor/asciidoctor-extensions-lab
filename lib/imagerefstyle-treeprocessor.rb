require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

DIAGRAM_TYPES = ['a2s', 'actdiag', 'blockdiag', 'ditaa', 'erd', 'graphviz', 'meme', 'mermaid', 'msc', 'nwdiag', 'packetdiag', 'plantuml', 'rackdiag', 'seqdiag', 'shaape', 'svgbob', 'syntrax', 'umlet', 'vega', 'vegalite', 'wavedrom']

Extensions.register do
  treeprocessor do
    process do |document|
      figureNumbers = {}
      document.find_by(context: :section) {|sect|
        if sect.level == 1
          figureNumbers[sect.level] = 0
          # how to specify multiple contexts better?
          sect.find_by(context: nil) {|obj|

            # select either images or literal blocks supported by asciidoctor-diagram
            if (obj.context == :image) || (obj.context == :literal && DIAGRAM_TYPES.include?(obj.attributes['1'])) 
                
                figureNumbers[sect.level] += 1

                obj.caption = 'Figure ' + sect.sectnum.to_s + figureNumbers[sect.level].to_s + '. '
                obj.attributes['reftext'] = obj.caption

                # literal blocks don't usually get titles in the same manner as images
                if obj.context == :literal && DIAGRAM_TYPES.include?(obj.attributes['1'])
                    obj.title = obj.caption + obj.title
                end
            end
          }
          
        end
      }
    end
    nil
  end
end