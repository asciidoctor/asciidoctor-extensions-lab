RUBY_ENGINE == 'opal' ? (require 'plantuml-block/extension') : (require_relative 'plantuml-block/extension')

Extensions.register do
    block PlantumlBlock
end
