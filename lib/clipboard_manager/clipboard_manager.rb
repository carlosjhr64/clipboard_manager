module ClipboardManager

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
  IS_PWD = Regexp.new(CONFIG[:IsPwd], Regexp::EXTENDED)
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
    @ask.active = (::ClipboardManager.options[:ask])? true : false
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
      (IS_PWD=~text)? yield(nil) : yield(text)
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
    self.methods.select{|m|m=~/^task_/}.sort.each do |mth|
      if self.method(mth).call(text)
        status(@ok)
        return 
      end
    end
    status(@nope)
  end

  def question?(wut)
    @ask.active? ? system("zenity --question --text='#{wut}'") : true
  end

  def task_999_espeak(text)
    if (text.length > 80) and question?('espeak?')
      CLIPBOARD.text=Rafini::Empty::STRING
      voices = ['en-gb', 'en-uk-north', 'en-uk-rp', 'en-uk-wmids', 'en-us']
      IO.popen("espeak --stdin -v #{voices[rand(voices.length)]}", 'w'){|e|e.puts text.strip}
      return true
    end
    return false
  end

  def task_020_amazon(text)
    if text=~/^https?:\/\/www.amazon.com\// and question?('amazon?')
      CLIPBOARD.text=Rafini::Empty::STRING
      system("firefox '#{text.strip}' &")
      return true
    end
    return false
  end

  def task_010_mplay(text)
    if text =~ /^https?:\/\/((vimeo.com)|(t.co)|((www\.)you((tube)|(porn))))/ and question?('mplay?')
      CLIPBOARD.text=Rafini::Empty::STRING
      system("mplay '#{text.strip}' &")
      return true
    end
    return false
  end

end
end
