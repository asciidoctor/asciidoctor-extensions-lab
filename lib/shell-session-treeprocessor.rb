require File.join File.dirname(__FILE__), 'shell-session-treeprocessor/extension'

Extensions.register do
  treeprocessor TerminalCommandTreeprocessor
end
