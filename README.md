# clipboard_manager

## DESCRIPTION:

Ruby Gtk3App Clipboard Manager.

## FEATURES

* history
* wget youtube-dl mplayer command to play youtube video
* firefox opens url
* espeak
* zbarcam qrcode

## INSTALL:

Note that you'll need gtk3app:

    $ sudo gem install gtk3app
    $ sudo gem install clipboard_manager

## CONFIGURATION:

After an initial run, your user configuration will found in:

    ~/.config/gtk3app/clipboardmanager/config-?.?.yml

Towards the bottom of the file you will find the available tasks:

    :tasks:
     :mplayer:
     - "(https?://www\\.youtube\\.com/watch\\?v=[\\w\\-]+)"
     - :bashit
     - true
     - wget --quiet -O - $(youtube-dl -f 5/36/17/18 -g '$1') | mplayer -really-quiet
       -cache 8192 -cache-min 1 -
     :firefox:
     - "^https?://"
     - :firefox
     - true
     :espeak:
     - ".{80,}"
     - :espeak
     - true

It is by this configuration that one can modify and add tasks.
With the boolean `true` value the clipboard will clear on the matched task.
If you don't want the clipboard cleared on a matched task,
set the boolean value to `false`.

The _mplayer_ task will run when the clipboard text matches a youtube link.
It will run the given system command `wget.. youtube_dl... '$1' | mplayer ...`,
where $1 will be replaced by the captured 1 match.

The _firefox_ task will run when the clipboard text matches a http address.
It will open the address with firefox.

The _espeak_ task will run when the clipboard text is at least 80 characters long.
It will have espeak read the text.

Currently, clipboard_manager has three tasks methods: bashit, firefox, and espeak.

For firefox and espeak, the pattern is used to recognize the text.
The whole copied text is used to pass on to firefox as a url, or espeak as text to be read.

bashit is more complicated.
It requires a command string which it will substitute $0, $1, $2... with match data.
It then passes the string to system.

See [clipboard_manager/clipboard_manager.rb](https://github.com/carlosjhr64/clipboard_manager/blob/master/lib/clipboard_manager/clipboard_manager.rb)
for details.
Specifically, methods #espeak, #firefox, and #bashit, which are called from #manage.

## HELP:

    Usage:
     clipboard_manager [:options+]
    Options:
     -v --version
     -h --help


## LICENSE:

(The MIT License)

Copyright (c) 2014 carlosjhr64

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
