## v1.0.0

* release date: **2017-12-31**

* **feature v0.3.1.11**
   - feature date: **2017-12-29**
   - bump version v0.3.1.11
   - update CHANGELOG
   - update `Gemfile`
   - views: `_footer.haml` strange behavior
   - controller: update, adapt `Mustemann` requirements
   - delete unneeded js files

* **feature v0.3.1.10**
   - feature date: **2017-06-10**
   - bump version v0.3.1.10
   - update CHANGELOG
   - controllers: `assets.rb` drop `compass`, use `sass,scss`
   - Gemfile, update gems, drop `compass`
   - assets: scss, `application.scss` and partials"
   - lib: remove `compass`, relay only on `sass`"
   - cleaning, delete unneeded files
   - assets: js, `trst_desk_buttons` add new print method
   - !strange! after updating my computer, required changes

* **feature v0.3.1.9**
   - feature date: **2016-10-09**
   - bump version v0.3.1.9
   - update CHANGELOG
   - assets: scss `_trst_base_class` added `fs-0.(X)rem` class
   - lib: `trst_helper`, `td_detail_for` + colspan
   - assets: js, `trst_desk_tables` window max height
   - Rakefile, switch to pry
   - Gemfile, switch to pry, ap bug mongoid 6.0.0 (BSON)
   - assets: js, add `handleIdPN` bugfix (add keyup event)
   - assets: js, `trst_desk_inputs` data-mark resize => size
   - views: base CRUD add class `%tfoot`
   - lib: `trst_helper` new method `details_for`

* **feature v0.3.1.8**
   - feature date: **2016-09-16**
   - bump version v0.3.1.8
   - update CHANGELOG
   - assets: css, `_trst_core`, add new rule
   - asstes: js, upgrade jQuery, jquery-ui
   - views: `public,system _html_head`, upgrade jQuery, jquery-ui
   - lib: `trst_helper` metadata -> __metadata :)
   - remove unused .bowerrc
   - models: `Trst::Address` remove unneeded defaults
   - models: `Trst::Person` remove unneeded defaults


* **feature v0.3.1.7**
   - feature date: **2016-08-26**
   - bump version v0.3.1.7
   - update CHANGELOG
   - assets: js, add `handleDownload`"
   - assets: js, bugfix `trst_desk_buttons`"
   - update `.js`"
   - upgrade fileDonload.js (v1.4.5)"


* **feature v0.3.1.6**
   - feature date: **2016-08-23**
   - bump version v0.3.1.6
   - update CHANGELOG
   - Gemfile, update mongoid, prawn
   - assets: js, bugfix `trst_desk_buttons`


* **feature v0.3.1.5**
   - feature date: **2016-08-17**
   - bump version v0.3.1.5
   - update CHANGELOG
   - assets: css, new rules
   - playing with the new ver. of mongoid


* **feature v0.3.1.4**
   - feature date: **2014-10-12**
   - bump version v0.3.1.4
   - update CHANGELOG
   - assets css `_trst_widget` add `pdt-05`
   - model `Trst::Cassation` change `id_intern` default to true
   - libs `trst_helper` add `td_detail_for` and related


* **feature v0.3.1.3**
   - feature date: **2014-09-28**
   - bump version v0.3.1.3
   - update CHANGELOG
   - views partials, apply [#41][#41], fix [#35][#35]
   - views CRUD, fix [#43][#43]
   - i18n add missing `trst_chache_book.yml`
   - assets js, cleanup, review, rewrite all, see [#35][#35], [#43][#43], fix [#44][#44]
   - libs `trst_helper` rewrite, see [#35][#35], [#43][#43], fix [#41][#41]


* **feature v0.3.1.2**
   - feature date: **2014-09-22**
   - bump version v0.3.1.2
   - update CHANGELOG
   - views: CRUD, partials fix [#43][#43]
   - views: layouts `public,system` partial <-> haml, see [#43][#43]
   - models `Trst::User` fix [#42][#4]2
   - models `Trst::ParnerPerson` typo
   - controllers `system` add class variables
   - lib `trst_helper` [#41][#41]


* **feature v0.3.1.1**
   - feature date: **2014-09-20**
   - bump version v0.3.1.1
   - update CHANGELOG
   - models `Document#freights_list` fix [#40][#40]
   - models `BSON::ObjectId` issue
   - models `Trst::Person|Firm` add Class-method `auto_search` fix [#38][#38]
   - models `.to_json` returns now `$oid:ID`


## v0.3.1 - hotfix-

* release date: **2014-09-18**, fix [#39][#39]
   - bump version v0.3.1
   - update CHANGELOG
   - assets css, small fix
   - controllers `system` Prawn v1.0.0 [#39][#39]
   - Gemfile Prawn v1.0.0 [#39][#39]


* **feature v0.3.0.1**, fix [#36][#36]
   - feature date: **2014-09-17**
   - bump version v0.3.0.1
   - update CHANGELOG
   - Rakefile cleanup and fix [#37][#37]
   - helpers, controllers, models ...  backwards incompatible  ... [#36][#36]
   - config `mongoid.yml` [#36][#36]
   - Gemfile upgrade mongoid [#36][#36]


## v0.3.0

* release date: **2014-09-17**
   - bump version v0.3.0
   - update CHANGELOG


* **feature v0.2.998**, v0.3.0 preparation
   - feature date: **2014-09-17**
   - bump version v0.2.999
   - update CHANGELOG
   - Gemfile, upgrade `sass`
   - assets css update
   - models `Trst::Book` missing `type: String`


* **feature v0.2.998**, v0.3.0 preparation
   - feature date: **2014-09-14**
   - bump version v0.2.998
   - update CHANGELOG
   - assets css, fix [#26][#26], fix [#28][#28]
   - views CRUD ugly fix [#30][#30], needs fix in js v1.0.0
   - models `Trst::DeliveryNote#freight_list` fix [#34][#34]
   - assets css, see issues [#25][#25], [#26][#26], [#27][#27], [#28][#28], [#31][#31]
   - views `system/tasks` missing help, fix [#31][#31]
   - views CRUD, cleanup fix [#33][#33]
   - views CRUD, `create` typo, fix [#32][#32]


* **feature v0.2.997**, v0.3.0 preparation
   - feature date: **2014-09-05**
   - bump version v0.2.997
   - update CHANGELOG
   - assets css, part of [issue #28][#28]
   - views CRUD cleanup and fix [issue #29][#29]
   - views new partial `_xhr_msg`, [issue #27][#27]
   - views layout, [issue #27][#27]
   - lib helper, [issue #27][#27]
   - controllers [issue #27][#27]
   - assets js, issues [#26][#26], [#27][#27]
   - assets css, issues [#26][#26], [#27][#27]


* **feature v0.2.996**, v0.3.0 preparation
   - feature date: **2014-08-31**
   - bump version v0.2.996
   - update CHANGELOG
   - views `system` default CRUD, use new `button|td_buttonset` help
   - assets: css, updated
   - assets js, use FontAwasome by default, for buttons [issue #20][#20]
   - lib `trst_helper` button, buttonset, fix [issue #23][#23]
   - models `Trst::Page` slug nil issue (todo ???)
   - controller `system` require Prawn dependencies, fix [issue #22][#22]
   - views `login.haml` adapt to new css
   - Gemfile cleanup, `gem 'sass', '3.4.1'` [issue #24][#24]


* **feature v0.2.995**, v0.3.0 preparation
   - feature date: **2014-08-29**
   - bump version v0.2.995
   - update CHANGELOG
   - Gemfile `prawn-table` fix [issue #21][#21]
   - complete rewrite stylesheets, [issue #17][#17]
   - assets css, cleanup
   - update js in `system`, [issue #17][#17], [issue #19][#19], [issue #20][#20]
   - update `system` layouts affected by [issue #17][#17]
   - update `public` layouts, pages affected by [issue #17][#17]
   - update js and views in `public`, [issue #19][#19], [issue #20][#20]
   - web components install directory [issue #16][#16]
   - update `.gitignore` .bowerrc


* **feature v0.2.994**, v0.3.0 preparation, [issue #11][#11], [issue #12][#12], [issue #13][#13], [issue #14][#14], [issue #15][#15]
   - feature date: **2014-08-21**
   - bump version v0.2.994
   - update CHANGELOG
   - update `.gitignore`
   - lib `compass_plugin` output settings
   - aseets css, `_trst_dialog` custom style for jQuery tooltip
   - assets js, add tooltip [issue #11][#11], login windows position, upgrade [issue #14][#14]
   - assets js, `main.js` upgrade JQuery 2.1.1, JQuery UI 1.11.1,[issue #14][#14]
   - views `system`,[issue #14][#14]
   - views `public`,[issue #14][#14], [issue #15][#15]
   - assets `webcomponents` empty folder (fill with bower),  [issue #13][#13]
   - controllers `assets.rb` switch to scss
   - assets `select2.css|js`,  update 3.5.2, [issue #14][#14]
   - fonts `font-awesome` update 4.1.0, [issue #14][#14]
   - assets `font-awesome.css`,  update 4.1.0, [issue #14][#14]
   - assets `application.css`,  use unique style in modules, fix [issue #12][#12]


* **feature v0.2.993**, v0.3.0 preparation
   - feature date: **2014-08-13**
   - bump version v0.2.993
   - update CHANGELOG
   - models `Trst::FreightStock` new scope `:stock_now`
   - models `Trst::Stock` skeleton
   - models `Trst::Payment` rename field `text` -> `expl`
   - models `Trst::DeliveryNote|Expenditure|Invoice|Sorting` cleanup, adapt `#increment_name`, `freights_list`
   - models `Trst::Cassation|Consumption|Grn` remove `dependent: :destroy`


* **feature v0.2.992**, v0.3.0 preparation
   - feature date: **2014-06-10**
   - bump version v0.2.992
   - update CHANGELOG
   - models `Clns` module related changes
   - lib `trst_main_helper` fix [issue #10][#10]


* **feature v0.2.991**, v0.3.0 preparation
   - feature date: **2014-06-08**
   - bump version v0.2.991
   - update CHANGELOG
   - models all, create skeleton, update relations, beutify


* **feature v0.2.990**, v0.3.0 preparation
   - feature date: **2014-06-05**
   - bump version v0.2.990
   - update CHANGELOG
   - prepare for v0.3.0
   - models `Trst::PartnerFirm|Person` cleanup, skeleton
   - models `TrstFreight|In|Out|Stock` cleanup, skeleton
   - models `Trst::Firm` fix [issue #9][#9]
   - lib helpers, cleanup, new helpers
   - config `seed/tasks.yml` add tasks
   - models `Trst::PartnerPerson` skeleton, overwrite in modules
   - models `Trst::PartnerFirm` skeleton, overwrite in modules
   - models `Trst::Unit` skeleton, use as embedded
   - models `Trst::Bank` skeleton, use as embedded


## v0.2.17
release date: **2014-06-01**

* i18n `trst.yml` monthly revision message
* controller `system.rb`, last day in month only root, fix [issue #8][#8]

## v0.2.16
release date: **2014-06-01**

* models `Trst::User` overwrite `#view_filter`, fix [issue #7][#7]

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
[#41]: https://github.com/kfl62/trst_sys_sinatra/issues/41
[#42]: https://github.com/kfl62/trst_sys_sinatra/issues/42
[#43]: https://github.com/kfl62/trst_sys_sinatra/issues/43
[#44]: https://github.com/kfl62/trst_sys_sinatra/issues/44
[#45]: https://github.com/kfl62/trst_sys_sinatra/issues/45
[#46]: https://github.com/kfl62/trst_sys_sinatra/issues/46
[#47]: https://github.com/kfl62/trst_sys_sinatra/issues/47
[#48]: https://github.com/kfl62/trst_sys_sinatra/issues/48
[#49]: https://github.com/kfl62/trst_sys_sinatra/issues/49
[#50]: https://github.com/kfl62/trst_sys_sinatra/issues/50
