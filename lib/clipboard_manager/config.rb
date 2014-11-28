module ClipboardManager

  HELP = <<-HELP # TODO
Usage: gtk3app clipboardmanager [options]
Options:
  --ask  Ask for confirmation on any action.
  HELP

  APPDIR = File.dirname File.dirname __dir__

  # pwd contains digit, lower case, upper case, special, and does not start like http://.
  IS_PWD =
    /\A
      (?!\w+:\/\/)          # not like url
      (?!\/[a-z]+\/[a-z])   # not like linux path
      (?![a-z]+\/[a-z]+\/)  # not like relative path
      (?=.*\d)              # at least on diget
      (?=.*[a-z])           # at least one lower case letter
      (?=.*[A-Z])           # at least one upper case letter
      (?=.*[^\w\s])         # at least one special character
      .{4,43}$              # 4 to 43 in length
    \Z/x

  CONFIG = {
    Help: HELP,

    TimeOut: 3,
    Sleep: 0.5,

    IsPwd: IS_PWD,

    Working: "#{XDG['DATA']}/gtk3app/clipboardmanager/working.png",
    Ok:      "#{XDG['DATA']}/gtk3app/clipboardmanager/ok.png",
    Nope:    "#{XDG['DATA']}/gtk3app/clipboardmanager/nope.png",
    Ready:   "#{XDG['DATA']}/gtk3app/clipboardmanager/ready.png",
    Off:     "#{XDG['DATA']}/gtk3app/clipboardmanager/off.png",

    thing: {

      HelpFile: "https://github.com/carlosjhr64/clipboard_manager",
      Logo: "#{XDG['DATA']}/gtk3app/clipboardmanager/logo.png",

      about_dialog: {
        set_program_name: 'Clipboard Manager',
        set_version: VERSION,
        set_copyright: '(c) 2014 CarlosJHR64',
        set_comments: 'A Ruby Gtk3App Clipboard Manager ',
        set_website: 'https://github.com/carlosjhr64/clipboard_manager',
        set_website_label: 'See it at GitHub!',
      },

      TOGGLE: ['Toggle On/Off'],
      toggle!: [:TOGGLE, 'activate'],

      window: {
        set_title: "Clipboard Manager",
        set_default_size: [200,100],
        set_window_position: :center,
      },

      VBOX: [:vertical],
      vbox!: [:VBOX],

      ASK: ['Ask for confimation.'],
      ask!: [:ASK],
    },
  }

end
