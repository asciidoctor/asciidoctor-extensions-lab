RUBY_ENGINE == 'opal' ? (require 'private-block/extension') : (require_relative 'private-block/extension')

Extensions.register do
  block PrivateBlock
end

