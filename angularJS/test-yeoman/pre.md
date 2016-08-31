#安装
cnpm install --global yo
output:
yo@1.8.4 /usr/local/lib/node_modules/yo
├── cli-list@0.1.8
├── titleize@1.0.0
├── async@1.5.2
├── user-home@2.0.0 (os-homedir@1.0.1)
├── opn@3.0.3 (object-assign@4.1.0)
├── humanize-string@1.0.1 (decamelize@1.2.0)
├── figures@1.7.0 (escape-string-regexp@1.0.5, object-assign@4.1.0)
├── chalk@1.1.3 (escape-string-regexp@1.0.5, supports-color@2.0.0, ansi-styles@2.2.1, strip-ansi@3.0.1, has-ansi@2.0.0)
├── string-length@1.0.1 (strip-ansi@3.0.1)
├── repeating@2.0.1 (is-finite

yo --version
output: 
1.8.4




cnpm install -g generator-angular（cnpm国内镜像）
output:
generator-angular@0.15.1 /usr/local/lib/node_modules/generator-angular
├── chalk@1.1.3 (supports-color@2.0.0, ansi-styles@2.2.1, escape-string-regexp@1.0.5, strip-ansi@3.0.1, has-ansi@2.0.0)
├── yosay@1.2.0 (strip-ansi@3.0.1, ansi-regex@2.0.0, ansi-styles@2.2.1, wrap-ansi@2.0.0, cli-boxes@1.0.0, pad-component@0.0.1, taketalk@1.0.0, repeating@2.0.1, string-width@1.0.2)
├── wiredep@2.2.2 (propprop@0.3.1, minimist@1.2.0, lodash@2.4.2, chalk@0.5.1, through2@0.6.5, glob@4.5.3, bower-config@0.5.2)
└── yeoman-generator@0.16.0 (diff@1.0.8, dargs@0.1.0, debug@0.7.4, async@0.2.10, isbinaryfile@2.0.4, mime@1.2.11, rimraf@2.2.8, findup-sync@0.1.3, text-table@0.2.0, chalk@0.4.0, mkdirp@0.3.5, lodash@2.4.2, class-extend@0.1.2, iconv-lite@0.2.11, underscore.string@2.3.3, shelljs@0.2.6, glob@3.2.11, request@2.30.0, file-utils@0.1.5, cheerio@0.13.1, inquirer@0.4.1, download@0.1.19)

other dependency:
cnpm install -g grunt-cli
cnpm install -g bower
cnpm install -g generator-karma


#使用
refenrence:
http://yeoman.io/codelab/

mkdir my-new-project
cd my-new-project
yo angular app1

- notes： select grunt ,do not select gulp (not stable...)
 
last-output:
Running "wiredep:test" (wiredep) task
Done, without errors.
Execution Time (2016-08-29 11:39:01 UTC+8)
loading tasks          234ms  ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 47%
loading grunt-wiredep    9ms  ▇ 2%
wiredep:app            239ms  ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 48%
wiredep:test            17ms  ▇▇ 3%
Total 500ms



