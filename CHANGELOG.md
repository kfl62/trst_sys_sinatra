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
