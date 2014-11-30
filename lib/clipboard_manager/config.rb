module ClipboardManager

  help = <<-HELP # TODO
Usage: gtk3app clipboardmanager [options]
Options:
  --ask      Ask for confirmation.
  --running  Start in active mode.
Default for options is true,
use no-ask and no-running for false.
  HELP

  APPDIR = File.dirname File.dirname __dir__

  is_pwd =
'\A
  (?!\w+:\/\/)          # not like url
  (?!\/[a-z]+\/[a-z])   # not like linux path
  (?![a-z]+\/[a-z]+\/)  # not like relative path
  (?=.*\d)              # at least on diget
  (?=.*[a-z])           # at least one lower case letter
  (?=.*[A-Z])           # at least one upper case letter
  (?=.*[^\w\s])         # at least one special character
  .{4,43}$              # 4 to 43 in length
\Z'

  a0 = Rafini::Empty::ARRAY
  h0 = Rafini::Empty::HASH
  s0 = Rafini::Empty::STRING

  CONFIG = {
    Help: help,

    TimeOut: 3,
    Sleep: 500,
    MaxHistory: 13,
    MaxString: 60,

    IsPwd: is_pwd,

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
        set_window_position: :center,
      },

      VBOX: [:vertical],
      vbox: h0,
      vbox!: [:VBOX, :vbox],

      ASK: ['Ask For Confirmation'],
      ask: h0,
      ask!: [:ASK, :ask],

      RUNNING: ['On/Off'],
      running: h0,
      running!: [:RUNNING, :running],

      TASKS: ['Tasks:'],
      tasks: h0,
      tasks!: [:TASKS, :tasks],

      HISTORY_BUTTON: [label: 'History'],
      history_button: h0,
      history_button!: [:HISTORY_BUTTON, :history_button],

      HISTORY_DIALOG: a0,
      history_dialog: h0,
      history_dialog!: [:HISTORY_DIALOG, :history_dialog],

      HISTORY_COMBO: a0,
      history_combo: h0,
      history_combo!: [:HISTORY_COMBO, :history_combo],

      QUESTION_DIALOG: a0,
      question_dialog: {
        set_window_position: :center,
        set_keep_above: true,
      },
      question_dialog!: [:question_dialog, :QUESTION_DIALOG],
    },

    # Note that Ruby 2 hashes preserves order, and order here is important.
    tasks: {
      mplayer: [
        'https?://www\.youtube\.com/\S+',
        :bashit,
        "wget -O - $(youtube-dl -f 5/36/17/18 -g '$0') | mplayer -really-quiet -cache 8192 -cache-min 1 -",
      ],
      firefox: ['^https?://www.amazon.com/', :firefox],
      espeak: ['.{80,}', :espeak],
    }
  }

end
