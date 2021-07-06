Gem::Specification.new do |s|

  s.name     = 'clipboard_manager'
  s.version  = '4.0.210706'

  s.homepage = 'https://github.com/carlosjhr64/clipboard_manager'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2021-07-06'
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
  s.add_runtime_dependency 'gtk3app', '~> 5.1', '>= 5.1.210203'
  s.add_runtime_dependency 'helpema', '~> 3.0', '>= 3.0.210706'
  s.requirements << 'espeak: eSpeak NG text-to-speech: 1.50  Data at: /usr/share/espeak-ng-data'
  s.requirements << 'system: linux/bash'
  s.requirements << 'ruby: ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]'
  s.requirements << 'xdg-open: xdg-open 1.1.3+'
  s.requirements << 'zbarcam: 0.23'

end
