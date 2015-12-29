Gem::Specification.new do |s|

  s.name     = 'clipboard_manager'
  s.version  = '1.1.1'

  s.homepage = 'https://github.com/carlosjhr64/clipboard_manager'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2015-12-22'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Ruby Gtk3App Clipboard Manager.
DESCRIPTION

  s.summary = <<SUMMARY
Ruby Gtk3App Clipboard Manager.
SUMMARY

  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options     = ["--main", "README.rdoc"]

  s.require_paths = ["lib"]
  s.files = %w(
README.rdoc
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
lib/clipboard_manager/version.rb
  )

  s.add_runtime_dependency 'helpema', '~> 0.1', '>= 0.1.0'
  s.requirements << 'ruby: ruby 2.2.3p173 (2015-08-18 revision 51636) [x86_64-linux]'
  s.requirements << 'gtk3app: 1.5.1'
  s.requirements << 'zbarcam: 0.10'
  s.requirements << 'firefox: Mozilla Firefox 38.0.5'
  s.requirements << 'espeak: eSpeak text-to-speech: 1.47.11  03.May.13  Data at: /usr/share/espeak-data'
  s.requirements << 'wget: GNU Wget 1.16.1 built on linux-gnu.'
  s.requirements << 'youtube-dl: 2015.12.18'
  s.requirements << 'system: linux/bash'

end
