class ClipboardManager
  HELP = <<~HELP
    Usage:
      clipboard_manager [:options+]
    Options:
      -h --help
      -v --version
      --minime\treal mimime
  HELP
  VERSION = '3.0.210705'

  def self.run
    # Standard Library
    require 'timeout'

    # Work gems
    require 'gtk3app'
    require 'helpema'

    # This Gem
    require_relative 'clipboard_manager/config.rb'
    require_relative 'clipboard_manager/clipboard_manager.rb'

    # Run
    Gtk3App.run(klass:ClipboardManager)
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
