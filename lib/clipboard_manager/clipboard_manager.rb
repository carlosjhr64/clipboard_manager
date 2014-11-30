module ClipboardManager
  using Rafini::Exception

  class Dialog < Such::Dialog
    def initialize(*par)
      super
      add_button(Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL)
      add_button(Gtk::Stock::OK, Gtk::ResponseType::OK)
    end

    def runs
      show_all
      response = run
      response = yield(response)
      destroy
      return response
    end
  end

  def self.options=(opts)
    @@options=opts
  end

  def self.options
    @@options
  end

  def self.run(program)
    ClipboardManager.new(program)
  end

class ClipboardManager
  CLIPBOARD = Gtk::Clipboard.get(Gdk::Selection::CLIPBOARD)

  def initialize(program)
    @program = program
    @image = program.mini.children.first
    @timer = nil

    @working = Gdk::Pixbuf.new(file: CONFIG[:Working])
    @ok      = Gdk::Pixbuf.new(file: CONFIG[:Ok])
    @nope    = Gdk::Pixbuf.new(file: CONFIG[:Nope])
    @ready   = Gdk::Pixbuf.new(file: CONFIG[:Ready])
    @off     = Gdk::Pixbuf.new(file: CONFIG[:Off])

    @is_pwd  = Regexp.new(CONFIG[:IsPwd], Regexp::EXTENDED)

    program.mini_menu.append_menu_item(:toggle!){toggle}
    status(@ready)

    window = program.window
    vbox = Such::Box.new window, :vbox!

    @running = Such::CheckButton.new(vbox, :running!, 'toggled'){toggled}
    @running.active = ::ClipboardManager.options[:running, true]

    @ask = Such::CheckButton.new vbox, :ask!
    @ask.active = ::ClipboardManager.options[:ask, true]

    Such::Label.new vbox, :tasks!

    @checks = {}
    CONFIG[:tasks].keys.each do |key|
      @checks[key] = Such::CheckButton.new(vbox, [key.to_s.capitalize], {set_active: true})
    end

    Such::Button.new(vbox, :history_button!){do_history}

    @history, @previous = [], nil
    request_text do |text|
      if text
        add_history text
        @previous = text
      end
      GLib::Timeout.add(CONFIG[:Sleep]) do
        step if @running.active?
        true # repeat
      end
    end

    window.show_all
  end

  # https://github.com/ruby-gnome2/ruby-gnome2/blob/master/gtk3/sample/misc/dialog.rb
  def do_history
    dialog = Dialog.new :history_dialog!
    combo = Such::ComboBoxText.new dialog.child, :history_combo!
    @history.each do |str|
      if str.length > CONFIG[:MaxString]
        n = CONFIG[:MaxString]/2 - 1
        str = "#{str[0..n]}...#{str[-n..-1]}"
      end
      combo.append_text(str)
    end
    dialog.runs do |response|
      if response==Gtk::ResponseType::OK and combo.active_text
        @previous = nil
        CLIPBOARD.text = @history[combo.active]
      end
    end
  end

  def question?(name)
    return true unless @ask.active?
    dialog = Dialog.new :question_dialog!
    Such::Label.new dialog.child, ["Run #{name}?"]
    dialog.runs{|response| (response==Gtk::ResponseType::OK)}
  end

  def toggled
    @running.active? ? status(@ready) : status(@off)
  end

  def toggle
    request_text do |text|
      @previous = text
      @running.active = !@running.active?
    end
  end

  def request_text
    CLIPBOARD.request_text do |_, text|
      # nil anything that looks like a pwd.
      (@is_pwd=~text)? yield(nil) : yield(text)
    end
  end

  def status(type)
    @image.set_pixbuf(type)
    @timer = Time.now
  end

  def step
    if @timer and Time.now - @timer > CONFIG[:TimeOut]
      @timer = nil
      status @ready
    end
    request_text do |text|
      unless text.nil? or @previous == text
        @previous = text
        status @working
        GLib::Timeout.add(0) do
          manage(text)
          false # don't repeat
        end
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
      rgx = Regexp.new(rgx, Regexp::EXTENDED)
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
          status(@nope) # TODO it's not just nope!
        end
        return
      end
    end
    status(@nope)
  end

  def espeak(text)
    Rafini.thread_bang!{IO.popen('espeak --stdin', 'w'){|e|e.puts text.strip}}
  end

  def firefox(text)
    raise "not a url" unless text =~ /^https?:\/\/\S+$/
    raise "quote not allowed in url" if text =~ /'/
    Process.detach spawn "firefox '#{text}'"
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
