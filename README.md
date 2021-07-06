# ClipboardManager

* [VERSION 4.0.210706](https://github.com/carlosjhr64/clipboard_manager/releases)
* [github](https://github.com/carlosjhr64/clipboard_manager)
* [rubygems](https://rubygems.org/gems/clipboard_manager)

## DESCRIPTION:

Ruby Gtk3App Clipboard Manager.

## FEATURES

Clipboard auto sends to:

* gnome-calculator
* google dictionary
* xdg-open url
* espeak

Also:

* History
* QR-Code copy to clipboard

## INSTALL:

Note that you'll need gtk3app:
```shell
$ gem install clipboard_manager
```
## CONFIGURATION:

After an initial run, your user configuration will found in:

    ~/.config/gtk3app/clipboardmanager/config-?.?.rbon

At top of the file you will find the available tasks:
```ruby
{
  Tasks!: {
    calculator: [
      "^([\\d\\.\\+\\-\\*\\/\\%\\(\\) ]{3,80})$",
      :bashit,
      true,
      "gnome-calculator -e '$1'"
    ],
    dictionary: [
      "^(\\w+)$",
      :bashit,
      true,
      "xdg-open 'https://www.google.com/search?q=definition+of+$1'"
    ],
    url: [
      "^https?://\\w[\\-\\+\\.\\w]*(\\.\\w+)(:\\d+)?(/\\S*)?$",
      :open,
      true
    ],
    espeak: [
      ".{80,}",
      :espeak,
      true
    ]
  },
  #...
}
```
It is by this configuration that one can modify and add tasks.
Warning: although the config file looks like `ruby` code,
it is read like a config file(not evaled).
Within tolerance(see [rbon](https://rubygems.org/gems/rbon)) you must maintain it's structure.

ClipboardManager has three tasks methods: `:bashit`, `:open`, and `:espeak`.
`:bashit` will take a command to be run by the system.
`:open` will `xdg-open` the clip.
`:espeak` will `espeak` the clip.

With the boolean `true` value the clipboard will clear on the matched task.
If you don't want the clipboard cleared on a matched task,
set the boolean value to `false`.

Note that `:bashit` requires a extra command string which
it will substitute $0, $1, $2... with match data.
It then passes the string to system.

The `:caculator` task will run when the clip looks like a bunch of number being operated.

The `:espeak` task will run when the clip is at least 80 characters long.
It will have espeak read the text.

## HELP:
```shell
$ clipboard_manager --help
Usage:
  clipboard_manager [:options+]
Options:
  -h --help
  -v --version
  --minime      	 Real minime
  --notoggle    	 Minime wont toggle decorated and keep above
  --notdecorated	 Dont decorate window
```
## LICENSE:

(The MIT License)

Copyright (c) 2021 CarlosJHR64

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
