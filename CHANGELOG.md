## v0.2.15
release date: **2014-05-30**

* models `Trst::Person` fix [issue #6][#6]
* models `Trst::Firm` fix [issue #4][#4]
* controllers `system.rb` fix [issue #5][#5]
* Gemfile mongoid use `:git => 'https://github.com/kfl62/mongoid.git', :branch => '3.1.0-stable'` until [mongoid issue][3] is solved

## v0.2.14
release date: **2014-05-26**

* fix [issue #3][#3]

## v0.2.13
release date: **2014-05-03**

* check clients system date before login
* keep error messages visible for 5s (2s)

## v0.2.12
release date: **2014-05-02**

* session expire in 12 hours, and related...

## v0.2.11
release date: **2014-04-30**

* rename `lib.version.rb` :(
* `.gitignore` ignore modules CHANGELOG, version

## v0.2.10
release date: **2014-04-24**

* models `Trst::Book|Page|Task` relations nil bugfix

## v0.2.9
release date: **2014-04-22**

* model `Trst::User` new field `id_pn` and related views...

## v0.2.8
release date: **2014-03-31**

* Add new module `trds`, Gemfile `bcrypt` gem related

## v0.2.7
release date: **2014-03-01**

* pdf reports, no file name bug fixed

## v0.2.6
release date: **2014-02-28**

* bundle update related changes

## v0.2.5
release date: **2013-11-12**

* `trst_helpers.rb` show values with precision
* controller `system.rb` handle `..\partial\..` routes

## v0.2.4

release date: **2013-07-24**

* patched `/public/javascripts/main.js` [select2 issue 1246][2]

* upgrade select2 library to v3.4.1

## v0.2.3

release date: **2013-07-22**

* hotfix v0.2.3: avoid `Moped::Errors::InvalidObjectId` errors in log files.

* Note: avoid robots.txt, favicon.ico 404 errors [nginx config file][1]

## v0.2.2

release date: **2013-07-21**

* hotfix v0.2.2: typo in CHANGELOG :)

## v0.2.1

release date: **2013-07-21**

* hotfix v0.2.1: mongoid configuration issue in production env.

## v0.2.0

release date: **2013-07-20**

* update JQuery v2.0.3, JQuery UI v.1.10.3

* `.gitignore` module related js

* `public\javasctipts\system` js (compiled coffeescripts) production ready

* `public\javasctipts\public` js (compiled coffeescripts) production ready

* `public\javasctipts\lib` js (compiled coffeescripts) production ready

* `public\javasctipts\lib` cleanup (remove jquery, jquery-ui)


## v0.1.0

release date: **2013-07-18**

* Started using git-flow `git flow init`

* Added **CHANGELOG**

* Move version from `config/trst.rb` to `lib/version.rb`

[1]: https://gist.github.com/kfl62/6049099
[2]: https://github.com/ivaynberg/select2/issues/1246 "Select2 search broken inside jQuery UI 1.10.x modal Dialog"
[3]: https://github.com/mongoid/mongoid/issues/3672 "issue 3672"
[#1]: https://github.com/kfl62/trst_sys_sinatra/issues/1
[#2]: https://github.com/kfl62/trst_sys_sinatra/issues/2
[#3]: https://github.com/kfl62/trst_sys_sinatra/issues/3
[#4]: https://github.com/kfl62/trst_sys_sinatra/issues/4
[#5]: https://github.com/kfl62/trst_sys_sinatra/issues/5
[#6]: https://github.com/kfl62/trst_sys_sinatra/issues/6
[#7]: https://github.com/kfl62/trst_sys_sinatra/issues/7
[#8]: https://github.com/kfl62/trst_sys_sinatra/issues/8
[#9]: https://github.com/kfl62/trst_sys_sinatra/issues/9
[#10]: https://github.com/kfl62/trst_sys_sinatra/issues/10
[#11]: https://github.com/kfl62/trst_sys_sinatra/issues/11
[#12]: https://github.com/kfl62/trst_sys_sinatra/issues/12
[#13]: https://github.com/kfl62/trst_sys_sinatra/issues/13
[#14]: https://github.com/kfl62/trst_sys_sinatra/issues/14
[#15]: https://github.com/kfl62/trst_sys_sinatra/issues/15
[#16]: https://github.com/kfl62/trst_sys_sinatra/issues/16
[#17]: https://github.com/kfl62/trst_sys_sinatra/issues/17
[#18]: https://github.com/kfl62/trst_sys_sinatra/issues/18
[#19]: https://github.com/kfl62/trst_sys_sinatra/issues/19
[#20]: https://github.com/kfl62/trst_sys_sinatra/issues/20
[#21]: https://github.com/kfl62/trst_sys_sinatra/issues/21
[#22]: https://github.com/kfl62/trst_sys_sinatra/issues/22
[#23]: https://github.com/kfl62/trst_sys_sinatra/issues/23
[#24]: https://github.com/kfl62/trst_sys_sinatra/issues/24
[#25]: https://github.com/kfl62/trst_sys_sinatra/issues/25
[#26]: https://github.com/kfl62/trst_sys_sinatra/issues/26
[#27]: https://github.com/kfl62/trst_sys_sinatra/issues/27
[#28]: https://github.com/kfl62/trst_sys_sinatra/issues/28
[#29]: https://github.com/kfl62/trst_sys_sinatra/issues/29
[#30]: https://github.com/kfl62/trst_sys_sinatra/issues/30
[#31]: https://github.com/kfl62/trst_sys_sinatra/issues/31
[#32]: https://github.com/kfl62/trst_sys_sinatra/issues/32
[#33]: https://github.com/kfl62/trst_sys_sinatra/issues/33
[#34]: https://github.com/kfl62/trst_sys_sinatra/issues/34
[#35]: https://github.com/kfl62/trst_sys_sinatra/issues/35
[#36]: https://github.com/kfl62/trst_sys_sinatra/issues/36
[#37]: https://github.com/kfl62/trst_sys_sinatra/issues/37
[#38]: https://github.com/kfl62/trst_sys_sinatra/issues/38
[#39]: https://github.com/kfl62/trst_sys_sinatra/issues/39
[#40]: https://github.com/kfl62/trst_sys_sinatra/issues/40
