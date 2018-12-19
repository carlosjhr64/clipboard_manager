Gem::Specification.new do |s|

  s.name     = 'clipboard_manager'
  s.version  = '3.0.0'

  s.homepage = 'https://github.com/carlosjhr64/clipboard_manager'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2018-12-19'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Ruby Gtk3App Clipboard Manager.
DESCRIPTION

  s.summary = <<SUMMARY
Ruby Gtk3App Clipboard Manager.
SUMMARY

  s.require_paths = ['lib']
  s.files = %w(
LICENSE
README.md
bin/clipboard_manager
data/VERSION
data/logo.png
data/nope.png
data/off.png
data/ok.png
data/ready.png
data/working.png
lib/clipboard_manager.rb
lib/clipboard_manager/clipboard_manager.rb
lib/clipboard_manager/config.rb
  )
  s.executables << 'clipboard_manager'
  s.add_runtime_dependency 'help_parser', '~> 6.5', '>= 6.5.0'
  s.add_runtime_dependency 'gtk3app', '~> 3.0', '>= 3.0.0'
  s.add_runtime_dependency 'helpema', '~> 1.0', '>= 1.0.1'
  s.requirements << 'ruby: ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-linux]'
  s.requirements << 'system: linux/bash'
  s.requirements << 'zbarcam: 0.20.1'
  s.requirements << 'firefox: Mozilla Firefox 63.0.3'
  s.requirements << 'espeak: eSpeak text-to-speech: 1.48.03  04.Mar.14  Data at: /usr/share/espeak-data'
  s.requirements << 'wget: GNU Wget 1.19.5 built on linux-gnu.'
  s.requirements << 'youtube-dl: 2018.11.07'

end
