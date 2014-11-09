require_relative 'ent2uni/extension'

Asciidoctor::Extensions.register do
    postprocessor EntToUni
end
