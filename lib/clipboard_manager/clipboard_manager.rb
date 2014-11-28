module ClipboardManager
  using Rafini::Exception

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
    @is_cmd  = Regexp.new(CONFIG[:IsCmd], Regexp::EXTENDED)

    @active     = true

    program.mini_menu.append_menu_item(:toggle!){toggle}
    status(@ready)

    request_text do |text|
      @previous = text
      Rafini.thread_bang!{cycle}
    end

    window = program.window
    vbox = Such::Box.new window, :vbox!
    @ask = Such::CheckButton.new vbox, :ask!
    @ask.active = ::ClipboardManager.options[:ask, true]
    window.show_all
  end

  def toggle
    request_text do |text|
      @previous = text
      @active = !@active
      @active? status(@ready) : status(@off)
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

  def cycle
    while true
      step if @active
      sleep CONFIG[:Sleep]
    end
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
        Rafini.thread_bang!{manage(text)}
      end
    end
  end

  def manage(text)
    CONFIG[:tasks].each do |name, _|
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
          when :system
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

  def question?(wut)
    @ask.active? ? system("zenity --question --text='#{wut}'") : true
  end

  def espeak(text)
    IO.popen('espeak --stdin', 'w'){|e|e.puts text.strip}
  end

  def firefox(text)
    raise "not a url" unless text =~ /^https?:\/\/\S+$/
    raise "quote not allowed in url" if text =~ /'/
    system("firefox '#{text}' &")
  end

  def bashit(md, str)
    (md.length-1).downto(0) do |i|
      str = str.gsub(/\$#{i}/, md[i])
      raise "Untrusted system command." unless @is_cmd =~ str
      $stderr.puts str if $VERBOSE
      system str
    end
  end

end
end
