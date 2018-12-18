module ClipboardManager
  VERSION = '3.0.0'

  def self.requires
    # Standard Libraries
    require 'timeout'

    # Work gems
    require 'gtk3app'
    require 'helpema/zbar'

    # This Gem
    require_relative 'clipboard_manager/config.rb'
    require_relative 'clipboard_manager/clipboard_manager.rb'
  end
end

# Requires:
#`ruby`
#`gtk3app`
#`zbarcam`
#`firefox`
#`espeak`
#`wget`
#`youtube-dl`
#`system`
