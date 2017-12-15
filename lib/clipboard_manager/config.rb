module ClipboardManager
  using Rafini::String

  APPDIR = File.dirname File.dirname __dir__

  is_pwd =
'\A
  (?!\w+:\/\/)          # not like url
  (?!\/[a-z]+\/[a-z])   # not like linux path
  (?![a-z]+\/[a-z]+\/)  # not like relative path
  (?=.*\d)              # at least one diget
  (?=.*[a-z])           # at least one lower case letter
  (?=.*[A-Z])           # at least one upper case letter
  (?=.*[^\w\s])         # at least one special character
  \S*$                  # no spaces
\Z'

  a0 = Rafini::Empty::ARRAY
  h0 = Rafini::Empty::HASH
  #s0 = Rafini::Empty::STRING

  CONFIG = {
    StatusTimeOut: 3,
    Sleep: 750,
    MaxHistory: 13,
    MaxString: 60,

    QrcTimeOut: 12,

    IsPwd: is_pwd,

    Espeak: 'espeak --stdin',
    Firefox: 'firefox',

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
        set_version: VERSION.semantic(0..1),
        set_copyright: '(c) 2015 CarlosJHR64',
        set_comments: 'A Ruby Gtk3App Clipboard Manager ',
        set_website: 'https://github.com/carlosjhr64/clipboard_manager',
        set_website_label: 'See it at GitHub!',
      },

      DO_TOGGLE: [label:'Toggle On/Off'],
      do_toggle!: [:DO_TOGGLE, 'activate'],

      DO_HISTORY: [label:'History'],
      do_history!: [:DO_HISTORY, 'activate'],

      DO_QRCODE: [label:'QR-Code'],
      do_qrcode!: [:DO_QRCODE, 'activate'],

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
      history_dialog: {
        set_window_position: :center,
      },
      history_dialog!: [:HISTORY_DIALOG, :history_dialog],

      HISTORY_COMBO: a0,
      history_combo: h0,
      history_combo!: [:HISTORY_COMBO, :history_combo],

      QRCODE_BUTTON: [label: 'QR-Code'],
      qrcode_button: h0,
      qrcode_button!: [:QRCODE_BUTTON, :qrcode_button],

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
        '(https?://www\.youtube\.com/watch\?v=[\w\-]+)',
        :bashit,
        "wget --quiet -O - $(youtube-dl -f 5/36/17/18 -g '$1') | mplayer -really-quiet -cache 8192 -cache-min 1 -",
      ],
      firefox: ['^https?://', :firefox],
      espeak: ['.{80,}', :espeak],
    }
  }

end
