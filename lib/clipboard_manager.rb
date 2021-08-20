class ClipboardManager
  class << self; attr_accessor :do_qrcode; end
  ClipboardManager.do_qrcode = true

  HELP = <<~HELP
    Usage:
      clipboard_manager [:options+]
    Options:
      -h --help
      -v --version
      --minime      \t Real minime
      --notoggle    \t Minime wont toggle decorated and keep above
      --notdecorated\t Dont decorate window
  HELP
  VERSION = '4.0.210820'


  def self.run

    # Gems
    require 'gtk3app'
    begin
      require 'helpema'
      ::Helpema::ZBar   # autoload
      require 'timeout' # needed to timeout zbarcam
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
#`gnome-calculator`
#`espeak`
#`system`
#`ruby`
#`xdg-open`
#`zbarcam`
