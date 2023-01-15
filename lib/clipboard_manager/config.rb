class ClipboardManager
  using Rafini::String # String#semantic
  extend Rafini::Empty # a0 and h0

  is_pwd =
'\A
  (?!\w+:\/\/)          # not like url
  (?!\/[a-z]+\/[a-z])   # not like linux path
  (?![a-z]+\/[a-z]+\/)  # not like relative path
  (?=.*\d)              # at least one digit
  (?=.*[a-z])           # at least one lower case letter
  (?=.*[A-Z])           # at least one upper case letter
  (?=.*[^\w\s])         # at least one special character
  \S*$                  # no spaces
\Z'

  CONFIG = {
    Tasks!: { # Note that Ruby's Hash preserves order, and order here is important.
      calculator: [
        '^([\d\.\+\-\*\/\%\(\) ]{3,80})$',
        :reply,
        true, # clears clipboard
      ],
      dictionary: [
        '^(\w+)$',
        :bashit,
        true, # clears clipboard
        "xdg-open 'https://en.wiktionary.org/wiki/$1'",
      ],
      url: ['^https?://\w[\-\+\.\w]*(\.\w+)(:\d+)?(/\S*)?$', :open, true],
      espeak: ['.{80,}', :espeak, true],
    },

    StatusTimeOut: 3,
    Sleep: 750,
    MaxHistory: 13,
    MaxString: 60,

    QrcTimeOut: 12,

    IsPwd: is_pwd,

    # The text-to-speech needs to be able to receive text from stdin
    Espeak: 'espeak',

    Working: "#{UserSpace::XDG['data']}/gtk3app/clipboardmanager/working.png",
    Ok:      "#{UserSpace::XDG['data']}/gtk3app/clipboardmanager/ok.png",
    Nope:    "#{UserSpace::XDG['data']}/gtk3app/clipboardmanager/nope.png",
    Ready:   "#{UserSpace::XDG['data']}/gtk3app/clipboardmanager/ready.png",
    Off:     "#{UserSpace::XDG['data']}/gtk3app/clipboardmanager/off.png",

    HelpFile: "https://github.com/carlosjhr64/clipboard_manager",
    Logo: "#{UserSpace::XDG['data']}/gtk3app/clipboardmanager/logo.png",

    ### Gui Things ###

    about_dialog: {
      set_program_name: 'Clipboard Manager',
      set_version: VERSION.semantic(0..1),
      set_copyright: '(c) 2023 CarlosJHR64',
      set_comments: 'A Ruby Gtk3App Clipboard Manager ',
      set_website: 'https://github.com/carlosjhr64/clipboard_manager',
      set_website_label: 'See it at GitHub!',
    },

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

    QRCODE_BUTTON: [label: 'QR-Code'],
    qrcode_button: h0,
    qrcode_button!: [:QRCODE_BUTTON, :qrcode_button],

    QUESTION_DIALOG: a0,
    question_dialog: {
      set_keep_above: true,
    },
    question_dialog!: [:question_dialog, :QUESTION_DIALOG],

    QUESTION_LABEL: a0,
    question_label: h0,
    question_label!: [:question_label, :QUESTION_LABEL],

    REPLY_LABEL: a0,
    reply_label: h0,
    reply_label!: [:reply_label, :REPLY_LABEL],

    REPLY_DIALOG: a0,
    reply_dialog: h0,
    reply_dialog!: [:reply_dialog, :REPLY_DIALOG],

    # Toggle's app-menu item.
    # Application MAY modify :TOGGLE for language.
    TOGGLE: [label: 'Toggle'],
    toggle: h0,
    toggle!: [:TOGGLE, :toggle, 'activate'],
    app_menu: {
      add_menu_item: [ :toggle!, :minime!, :help!, :about!, :quit!  ],
    },
  }
end
