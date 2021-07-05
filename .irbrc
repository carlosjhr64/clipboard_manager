begin
  require 'clipboard_manager'
  msg = ClipboardManager::VERSION
rescue Exception
  msg = $!.message
end
require 'irbtools/configure'
Irbtools.welcome_message="### ClipboardManager(#{msg})###"
Irbtools.start
