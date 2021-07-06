class ClipboardManager
  class << self; attr_accessor :do_qrcode; end
  ClipboardManager.do_qrcode = true

  HELP = <<~HELP
    Usage:
      clipboard_manager [:options+]
    Options:
      -h --help
      -v --version
      --minime    \t real minime
  HELP
  VERSION = '4.0.210706'


  def self.run
    # Standard Library
    require 'timeout'

    # Work gems
    require 'gtk3app'
    begin
      require 'helpema'
      ::Helpema::ZBar # autoload
    rescue
      # no ZBar? OK, nevermind.
      ClipboardManager.do_qrcode = false
    end

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
