module ClipboardManager
  using Rafini::Exception

  def self.run(program)
    ClipboardManager.new(program)
  end

class ClipboardManager
  CLIPBOARD = Gtk::Clipboard.get(Gdk::Selection::CLIPBOARD)

  def initialize(program)
    @image = program.mini.children.first
    @timer = nil

    @working = GdkPixbuf::Pixbuf.new(file: CONFIG[:Working])
    @ok      = GdkPixbuf::Pixbuf.new(file: CONFIG[:Ok])
    @nope    = GdkPixbuf::Pixbuf.new(file: CONFIG[:Nope])
    @ready   = GdkPixbuf::Pixbuf.new(file: CONFIG[:Ready])
    @off     = GdkPixbuf::Pixbuf.new(file: CONFIG[:Off])

    @is_pwd  = Regexp.new(CONFIG[:IsPwd], Regexp::EXTENDED)

    @window = program.window
    vbox = Such::Box.new @window, :vbox!

    @running = Such::CheckButton.new(vbox, :running!, 'toggled'){toggled}
    @running.active = true

    @ask = Such::CheckButton.new vbox, :ask!
    @ask.active = true

    Such::Label.new vbox, :tasks!

    @checks = {}
    CONFIG[:tasks].keys.each do |key|
      @checks[key] = Such::CheckButton.new(vbox, [key.to_s.capitalize], {set_active: true})
    end

    Such::Button.new(vbox, :history_button!){do_history!}
    Such::Button.new(vbox, :qrcode_button!){do_qrcode!}

    mm = program.mini_menu
    mm.append_menu_item(:do_toggle!){do_toggle!}
    mm.append_menu_item(:do_history!){do_history!}
    mm.append_menu_item(:do_qrcode!){do_qrcode!}

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

    status(@ready)
    @window.show_all
  end

  # https://github.com/ruby-gnome2/ruby-gnome2/blob/master/gtk3/sample/misc/dialog.rb
  def do_history!
    dialog = Gtk3App::Dialog::CancelOk.new(:history_dialog!)
    dialog.transient_for = @window
    combo = dialog.combo :history_combo!
    @history.each do |str|
      if str.length > CONFIG[:MaxString]
        n = CONFIG[:MaxString]/2 - 1
        str = "#{str[0..n]}...#{str[-n..-1]}"
      end
      combo.append_text(str)
    end
    dialog.runs do |response|
      if response == Gtk::ResponseType::OK and combo.active_text
        @previous = nil
        CLIPBOARD.text = @history[combo.active]
      end
    end
  end

  def do_qrcode!
    qrcode = Helpema::ZBar.cam(CONFIG[:QrcTimeOut])
    if qrcode.nil?
      CLIPBOARD.clear
      status(@nope)
    else
      CLIPBOARD.text = qrcode
      status(@ok)
    end
  end

  def question?(name)
    return true unless @ask.active?
    dialog = Gtk3App::Dialog::NoYes.new :question_dialog!
    dialog.transient_for = @window
    dialog.label.text = "Run #{name}?"
    dialog.runs
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
    CONFIG[:tasks].each do |name, _|
      next unless @checks[name].active?
      rgx, mth, str = _
      rgx = Regexp.new(rgx, Regexp::EXTENDED | Regexp::MULTILINE)
      if md=rgx.match(text) and question?(name)
        CLIPBOARD.text=Rafini::Empty::STRING
        begin
          case mth
          when :espeak
            espeak(text)
          when :firefox
            firefox(text)
          when :bashit
            bashit(md, str)
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

  def espeak(text)
    Rafini.thread_bang!{IO.popen(CONFIG[:Espeak], 'w'){|e|e.puts text.strip}}
  end

  def firefox(text)
    raise "quote not allowed in url" if text =~ /'/
    Process.detach spawn "#{CONFIG[:Firefox]} '#{text}'"
  end

  def bashit(md, str)
    (md.length-1).downto(0) do |i|
      str = str.gsub(/\$#{i}/, md[i])
    end
    $stderr.puts str
    Process.detach spawn str
  end

end
end
