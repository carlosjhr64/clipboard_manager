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

    CLIPBOARD.request_text do |_, text|
      @previous = text
      Rafini.thread_bang!{cycle}
    end

    window = program.window
    vbox = Such::Box.new window, :vbox!
    @ask = Such::CheckButton.new vbox, :ask!
    @ask.active = (::ClipboardManager.options[:ask])? true : false
    window.show_all
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
    CLIPBOARD.request_text do |_, text|
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

  def toggle
    CLIPBOARD.request_text do |_, text|
      @previous = text
      @active = !@active
      @active? status(@ready) : status(@off)
    end
  end

  def question?(wut)
    @ask.active? ? system("zenity --question --text='#{wut}'") : true
  end

  def task_010_espeak(text)
    if (text.length > 80 or text=~/\n/) and question?('espeak?')
      CLIPBOARD.text=Rafini::Empty::STRING
      voices = ['en-gb', 'en-uk-north', 'en-uk-rp', 'en-uk-wmids', 'en-us']
      IO.popen("espeak --stdin -v #{voices[rand(voices.length)]}", 'w'){|e|e.puts text.strip}
      return true
    end
    return false
  end

  def task_020_amazon(text)
    if text=~/^https?:\/\/www.amazon.con\// and question?('amazon?')
      CLIPBOARD.text=Rafini::Empty::STRING
      system("firefox '#{text.strip}' &")
      return true
    end
    return false
  end

  def task_030_mplay(text)
    if text =~ /^https?:\/\/((vimeo.com)|(t.co)|((www\.)you((tube)|(porn))))/ and question?('mplay?')
      CLIPBOARD.text=Rafini::Empty::STRING
      system("mplay '#{text.strip}' &")
      return true
    end
    return false
  end

end
end
