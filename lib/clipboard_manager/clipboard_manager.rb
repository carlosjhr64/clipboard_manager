def Gtk3App.toggle!
  @clipboard_manager_hook.do_toggle!
end

def Gtk3App.clipboard_manager_hook(hook)
  @clipboard_manager_hook = hook
end

class ClipboardManager
  using Rafini::Exception

  class NoYes < Such::Dialog
    def initialize(key)
      super
      add_button '_No', Gtk::ResponseType::CANCEL
      add_button '_Yes', Gtk::ResponseType::OK
    end

    def label(key)
      Such::Label.new child, key
    end

    def ok?
      show_all
      response = run
      destroy
      response == Gtk::ResponseType::OK
    end
  end

  class CancelOk < Such::Dialog
    def initialize(key)
      super
      add_button(Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL)
      add_button(Gtk::Stock::OK, Gtk::ResponseType::OK)
    end

    def combo(key)
      Such::ComboBoxText.new child, key
    end

    def runs
      show_all
      response = run
      yield if response == Gtk::ResponseType::OK
      destroy
    end
  end

  class Message < Such::Dialog
    def initialize(key)
      super
      add_button '_OK', Gtk::ResponseType::OK
    end

    def label(key)
      Such::Label.new child, key
    end

    def runs
      show_all
      response = run
      destroy
    end
  end

  CLIPBOARD = Gtk::Clipboard.get(Gdk::Selection::CLIPBOARD)

  def initialize(stage, toolbar, options)
    @image = toolbar.parent.children[0].child # Expander:hbox:EventImage:Image
    @timer = nil

    @working = GdkPixbuf::Pixbuf.new(file: CONFIG[:Working])
    @ok      = GdkPixbuf::Pixbuf.new(file: CONFIG[:Ok])
    @nope    = GdkPixbuf::Pixbuf.new(file: CONFIG[:Nope])
    @ready   = GdkPixbuf::Pixbuf.new(file: CONFIG[:Ready])
    @off     = GdkPixbuf::Pixbuf.new(file: CONFIG[:Off])

    @is_pwd  = Regexp.new(CONFIG[:IsPwd], Regexp::EXTENDED)

    vbox = Such::Box.new(stage, :vbox!)
    @running = Such::CheckButton.new(vbox, :running!, 'toggled'){toggled}
    @running.active = true

    @ask = Such::CheckButton.new vbox, :ask!
    @ask.active = true

    Such::Label.new vbox, :tasks!

    @checks = {}
    CONFIG[:Tasks!].keys.each do |key|
      @checks[key] = Such::CheckButton.new(vbox, [key.to_s.capitalize], {set_active: true})
    end

    Such::Button.new(vbox, :history_button!){do_history!}
    Such::Button.new(vbox, :qrcode_button!){do_qrcode!} if ClipboardManager.do_qrcode

    @history, @previous = [], nil
    text = request_text
    if text
      add_history text
      @previous = text
    end
    GLib::Timeout.add(CONFIG[:Sleep]) do
      step if @running.active?
      true # repeat
    end

    Gtk3App.clipboard_manager_hook(self)

    status(@ready)
  end

  # https://github.com/ruby-gnome2/ruby-gnome2/blob/master/gtk3/sample/misc/dialog.rb
  def do_history!
    dialog = CancelOk.new(:history_dialog!)
    Gtk3App.transient dialog
    combo = dialog.combo :history_combo!
    @history.each do |str|
      if str.length > CONFIG[:MaxString]
        n = CONFIG[:MaxString]/2 - 1
        str = "#{str[0..n]}...#{str[-n..-1]}"
      end
      combo.append_text(str)
    end
    dialog.runs do
      if combo.active_text
        @previous = nil
        CLIPBOARD.text = @history[combo.active]
      end
    end
  end

  def do_qrcode!
    qrcode = Timeout::timeout(CONFIG[:QrcTimeOut]){ Helpema::ZBar.cam() }
    CLIPBOARD.text = qrcode
    status(@ok)
  rescue
    $!.puts
    CLIPBOARD.clear
    status(@nope)
  end

  def question?(name)
    return true unless @ask.active?
    dialog = NoYes.new :question_dialog!
    Gtk3App.transient dialog
    dialog.label(:question_label!).text = "Run #{name}?"
    dialog.ok?
  end

  def toggled
    @running.active? ? status(@ready) : status(@off)
  end

  def do_toggle!
    text = request_text
    @previous = text
    @running.active = !@running.active?
  end

  def request_text
    if text = CLIPBOARD.wait_for_text
      text.strip!
      return text unless text.empty? or @is_pwd.match?(text)
    end
    nil
  end

  def status(type)
    @image.set_pixbuf(type)
    @timer = Time.now
  end

  def step
    if @timer and Time.now - @timer > CONFIG[:StatusTimeOut]
      @timer = nil
      status @ready
    end
    text = request_text
    unless text.nil? or @previous == text
      @previous = text
      status @working
      GLib::Timeout.add(0) do
        manage(text)
        false # don't repeat
      end
    end
  end

  def add_history(text)
    @history.unshift text
    @history.uniq!
    @history.pop if @history.length > CONFIG[:MaxHistory]
  end

  def manage(text)
    add_history text
    CONFIG[:Tasks!].each do |name, _|
      next unless @checks[name].active?
      rgx, mth, clr, str = _
      rgx = Regexp.new(rgx, Regexp::EXTENDED | Regexp::MULTILINE)
      if md=rgx.match(text) and question?(name)
        CLIPBOARD.clear if clr
        begin
          case mth
          when :espeak
            espeak(text)
          when :open
            open(text)
          when :bashit
            bashit(md, str)
          when :reply
            reply(text)
          else
            raise "Method #{mth} not implemented."
          end
          status(@ok)
        rescue RuntimeError
          $!.puts
          status(@nope)
        end
        return
      end
    end
    status(@nope)
  end

  ESPEAK = IO.popen(CONFIG[:Espeak], 'w')
  Gtk3App.finalize{ESPEAK.close}
  def espeak(text)
    Rafini.thread_bang!{ESPEAK.puts text.strip}
  end

  def open(text)
    Process.detach spawn CONFIG[:Open], text
  end

  def bashit(md, str)
    (md.length-1).downto(0) do |i|
      str = str.gsub(/\$#{i}/, md[i] || '')
    end
    $stderr.puts str
    Process.detach spawn str
  end

  def reply(text)
    dialog = Message.new(:reply_dialog!)
    Gtk3App.transient dialog
    begin
      dialog.label(:reply_label!).text = "#{text} #=> #{eval text}"
    rescue
      dialog.label.text = $!.message
    end
    dialog.runs
  end
end
