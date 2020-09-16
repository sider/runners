# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

[Full diff](https://github.com/sider/runners/compare/0.34.1...HEAD)

Updated tools:

- **Brakeman** 4.9.0 -> 4.9.1 [#1450](https://github.com/sider/runners/pull/1450)
- **Checkstyle** 8.35 -> 8.36.1 [#1466](https://github.com/sider/runners/pull/1466)
- **detekt** 1.11.2 -> 1.13.1 [#1468](https://github.com/sider/runners/pull/1468)
- **ESLint** 7.7.0 -> 7.9.0 [#1469](https://github.com/sider/runners/pull/1469)
- **GolangCI-Lint** 1.30.0 -> 1.31.0 [#1465](https://github.com/sider/runners/pull/1465)
- **Goodcheck** 2.5.1 -> 2.5.2 [#1445](https://github.com/sider/runners/pull/1445)
- **ktlint** 0.37.2 -> 0.39.0 [#1435](https://github.com/sider/runners/pull/1435) [#1482](https://github.com/sider/runners/pull/1482)
- **PMD CPD** 6.26.0 -> 6.27.0 [#1447](https://github.com/sider/runners/pull/1447)
- **PMD Java** 6.26.0 -> 6.27.0 [#1448](https://github.com/sider/runners/pull/1448)
- **Pylint** 2.5.3 -> 2.6.0 [#1407](https://github.com/sider/runners/pull/1407)
- **stylelint** 13.6.1 -> 13.7.1 [#1472](https://github.com/sider/runners/pull/1472)

Misc:

- **Cppcheck** Run multiple threads with the `-j` option [#1462](https://github.com/sider/runners/pull/1462)
- **RuboCop** Add `standard` to optional gem list [#1479](https://github.com/sider/runners/pull/1479)
- **RuboCop** Improve warning messages [#1480](https://github.com/sider/runners/pull/1480)
- Replace ENTRYPOINT with docker-entrypoint.sh [#1463](https://github.com/sider/runners/pull/1463)
- Make generated `Gemfile` content log valid as Ruby [#1485](https://github.com/sider/runners/pull/1485)

## 0.34.1

[Full diff](https://github.com/sider/runners/compare/0.34.0...0.34.1)

- Reconsider `Results::Failure` message [#1459](https://github.com/sider/runners/pull/1459)

## 0.34.0

[Full diff](https://github.com/sider/runners/compare/0.33.0...0.34.0)

Breaking changes:

- Remove :owner and :repo, and rename :git_http_url and :git_http_userinfo [#1411](https://github.com/sider/runners/pull/1411)
- Replace :pull_number with :refspec [#1412](https://github.com/sider/runners/pull/1412)
- Unify `S3_ENDPOINT` to `RUNNERS_OPTIONS` [#1414](https://github.com/sider/runners/pull/1414)

## 0.33.0

[Full diff](https://github.com/sider/runners/compare/0.32.2...0.33.0)

Updated environments:

- **devon_rex** 2.24.0 -> 2.25.0 [#1404](https://github.com/sider/runners/pull/1404) [#1405](https://github.com/sider/runners/pull/1405)

Updated tools:

- **Brakeman** 4.8.2 -> 4.9.0 [#1376](https://github.com/sider/runners/pull/1376)
- **cpplint** 1.5.3 -> 1.5.4 [#1401](https://github.com/sider/runners/pull/1401)
- **detekt** 1.10.0 -> 1.11.2 [#1399](https://github.com/sider/runners/pull/1399)
- **ESLint** 7.6.0 -> 7.7.0 [#1393](https://github.com/sider/runners/pull/1393)
- **FxCop** 3.0.0 -> 3.3.0 [#1384](https://github.com/sider/runners/pull/1384)
- **GolangCI-Lint** 1.29.0 -> 1.30.0 [#1372](https://github.com/sider/runners/pull/1372)
- **JSHint** 2.11.2 -> 2.12.0 [#1379](https://github.com/sider/runners/pull/1379)
- **PHP_CodeSniffer** 3.5.5 -> 3.5.6 [#1389](https://github.com/sider/runners/pull/1389)
- **RuboCop** 0.88.0 -> 0.89.1 [#1381](https://github.com/sider/runners/pull/1381)
- **SwiftLint** 0.39.2 -> 0.40.0 [#1385](https://github.com/sider/runners/pull/1385)

Misc:

- **stylelint** Add `stylelint-config-prettier` as pre-installed package [#1396](https://github.com/sider/runners/pull/1396)
- **stylelint** Add `stylelint-prettier` as a pre-installed package [#1402](https://github.com/sider/runners/pull/1402)

## 0.32.2

[Full diff](https://github.com/sider/runners/compare/0.32.1...0.32.2)

- **PHPMD** Improve runtime error message [#1383](https://github.com/sider/runners/pull/1383)

## 0.32.1

[Full diff](https://github.com/sider/runners/compare/0.32.0...0.32.1)

- **Rails Best Practices** Improve error message [#1371](https://github.com/sider/runners/pull/1371)

## 0.32.0

[Full diff](https://github.com/sider/runners/compare/0.31.0...0.32.0)

Breaking changes:

- **ktlint** Support `jvm_deps` and remove `cli`, `gradle`, `maven` [#1364](https://github.com/sider/runners/pull/1364)

Updated environments:

- **devon_rex** 2.23.0 -> 2.24.0 [#1370](https://github.com/sider/runners/pull/1370)

Updated tools:

- **ESLint** 7.5.0 -> 7.6.0 [#1368](https://github.com/sider/runners/pull/1368)
- **JSHint** 2.11.1 -> 2.11.2 [#1366](https://github.com/sider/runners/pull/1366)
- **TSLint** 6.1.2 -> 6.1.3 [#1369](https://github.com/sider/runners/pull/1369)
- **TyScan** 0.3.1 -> 0.3.2 [#1354](https://github.com/sider/runners/pull/1354)

Misc:

- Download JVM dependencies via Gradle [#1352](https://github.com/sider/runners/pull/1352)
- Install 3rd-party JVM dependencies via `sider.yml` [#1361](https://github.com/sider/runners/pull/1361)
- Add `config_file` to result [#1363](https://github.com/sider/runners/pull/1363)

## 0.31.0

[Full diff](https://github.com/sider/runners/compare/0.30.0...0.31.0)

Updated environments:

- **devon_rex** 2.22.0 -> 2.23.0 [#1348](https://github.com/sider/runners/pull/1348)

Updated tools:

- **Checkstyle** 8.34 -> 8.35 [#1331](https://github.com/sider/runners/pull/1331)
- **cpplint** 1.5.2 -> 1.5.3 [#1346](https://github.com/sider/runners/pull/1346)
- **ESLint** 7.4.0 -> 7.5.0 [#1344](https://github.com/sider/runners/pull/1344)
- **GolangCI-Lint** 1.28.3 -> 1.29.0 [#1340](https://github.com/sider/runners/pull/1340)
- **PMD CPD** 6.25.0 -> 6.26.0 [#1333](https://github.com/sider/runners/pull/1333)
- **PMD Java** 6.25.0 -> 6.26.0 [#1329](https://github.com/sider/runners/pull/1329)
- **remark-lint** 8.0.0 -> 8.0.1 [#1337](https://github.com/sider/runners/pull/1337)
- **RuboCop** 0.87.1 -> 0.88.0 [#1328](https://github.com/sider/runners/pull/1328)

Misc:

- **Brakeman** Syntax highlight for warning message [#1309](https://github.com/sider/runners/pull/1309)
- **Cppcheck** Support `-I` option to handle include paths [#1314](https://github.com/sider/runners/pull/1314)
- **stylelint** Add `stylelint-order` to pre-installed list [#1310](https://github.com/sider/runners/pull/1310)
- Optimize git-blame [#1312](https://github.com/sider/runners/pull/1312)
- Remove unused `Result::MissingFilesFailure` [#1315](https://github.com/sider/runners/pull/1315)
- Avoid needless calculation of changed files [#1320](https://github.com/sider/runners/pull/1320)
- Fix non-ascii filename on git-diff [#1323](https://github.com/sider/runners/pull/1323)

## 0.30.0

[Full diff](https://github.com/sider/runners/compare/0.29.3...0.30.0)

New supported:

- **Clang-Tidy** [#1254](https://github.com/sider/runners/pull/1254)

Updated environments:

- **devon_rex** 2.20.0 -> 2.22.0 [#1244](https://github.com/sider/runners/pull/1244) [#1278](https://github.com/sider/runners/pull/1278)

Updated tools:

- **Checkstyle** 8.33 -> 8.34 [#1239](https://github.com/sider/runners/pull/1239)
- **cpplint** 1.5.1 -> 1.5.2 [#1222](https://github.com/sider/runners/pull/1222)
- **detekt** 1.9.1 -> 1.10.0 [#1236](https://github.com/sider/runners/pull/1236)
- **ESLint** 7.2.0 -> 7.4.0 [#1224](https://github.com/sider/runners/pull/1224) [#1267](https://github.com/sider/runners/pull/1267)
- **GolangCI-Lint** 1.27.0 -> 1.28.3 [#1266](https://github.com/sider/runners/pull/1266) [#1273](https://github.com/sider/runners/pull/1273) [#1289](https://github.com/sider/runners/pull/1289) [#1297](https://github.com/sider/runners/pull/1297)
- **LanguageTool** 4.9.1 -> 5.0 [#1241](https://github.com/sider/runners/pull/1241)
- **PMD CPD** 6.24.0 -> 6.25.0 [#1235](https://github.com/sider/runners/pull/1235)
- **PMD Java** 6.24.0 -> 6.25.0 [#1237](https://github.com/sider/runners/pull/1237)
- **RuboCop** 0.85.1 -> 0.87.1 [#1220](https://github.com/sider/runners/pull/1220) [#1281](https://github.com/sider/runners/pull/1281)

Misc:

- Use Docker BuildKit [#1245](https://github.com/sider/runners/pull/1245)
- Fix Kotlin file extensions [#1252](https://github.com/sider/runners/pull/1252)
- Increase :tries and :sleep of Retryable for git-fetch(1) [#1279](https://github.com/sider/runners/pull/1279)
- Allow `location(start_line,start_column)` format [#1257](https://github.com/sider/runners/pull/1257)
- Make deprecation warning messages more useful [#1292](https://github.com/sider/runners/pull/1292)
- Prevent unexpected error when missing issue ID [#1301](https://github.com/sider/runners/pull/1301)
- Avoid git-blame when base commit is not given [#1307](https://github.com/sider/runners/pull/1307)
- **ESLint** Add `target` option instead of `dir` option [#1264](https://github.com/sider/runners/pull/1264)
- **ESLint** Pre-install popular configs and plugins [#1271](https://github.com/sider/runners/pull/1271)
- **ESLint** Update the default configuration [#1270](https://github.com/sider/runners/pull/1270)
- **ESLint** Set `ecmaVersion:2015` to the default configuration [#1290](https://github.com/sider/runners/pull/1290)
- **Flake8** Support `target` and `config` options [#1287](https://github.com/sider/runners/pull/1287)
- **GolangCI-Lint** Add `severity` and `replacement` to issue result [#1268](https://github.com/sider/runners/pull/1268)
- **HAML-Lint** Add `target` option [#1265](https://github.com/sider/runners/pull/1265)
- **HAML-Lint** Fix `line: 0` [#1306](https://github.com/sider/runners/pull/1306)
- **Misspell** Support `ignore` option as array [#1255](https://github.com/sider/runners/pull/1255)
- **PHP_CodeSniffer** Remove deprecated `version` option [#1291](https://github.com/sider/runners/pull/1291)
- **PHPMD** Support the comma-separated list options as array [#1253](https://github.com/sider/runners/pull/1253)
- **Querly** Support `config` option [#1288](https://github.com/sider/runners/pull/1288)
- **stylelint** Pre-install popular configs and plugins [#1272](https://github.com/sider/runners/pull/1272)

## 0.29.3

[Full diff](https://github.com/sider/runners/compare/0.29.2...0.29.3)

- **Rails Best Practices** Fix invalid line number [#1242](https://github.com/sider/runners/pull/1242)

## 0.29.2

[Full diff](https://github.com/sider/runners/compare/0.29.1...0.29.2)

- **Rails Best Practices** Re-challenge to fix invalid line number [#1240](https://github.com/sider/runners/pull/1240)

## 0.29.1

[Full diff](https://github.com/sider/runners/compare/0.29.0...0.29.1)

- **Rails Best Practices** Fix invalid line number [#1232](https://github.com/sider/runners/pull/1232)

## 0.29.0

[Full diff](https://github.com/sider/runners/compare/0.28.3...0.29.0)

- **Rails Best Practices** 1.19.4 -> 1.20.0 [#1228](https://github.com/sider/runners/pull/1228)
- **Rails Best Practices** More info in warning message [#1230](https://github.com/sider/runners/pull/1230)

## 0.28.3

[Full diff](https://github.com/sider/runners/compare/0.28.2...0.28.3)

- **Rails Best Practices** Fix invalid `line_number` [#1216](https://github.com/sider/runners/pull/1216)

## 0.28.2

[Full diff](https://github.com/sider/runners/compare/0.28.1...0.28.2)

- **Rails Best Practices** Improvements [#1213](https://github.com/sider/runners/pull/1213)
- Retry git-fetch(1) and git-checkout(1) [#1214](https://github.com/sider/runners/pull/1214)

## 0.28.1

[Full diff](https://github.com/sider/runners/compare/0.28.0...0.28.1)

- **Brakeman** Fix warning in Markdown [#1206](https://github.com/sider/runners/pull/1206)
- **RuboCop** Fix broken document link [#1207](https://github.com/sider/runners/pull/1207)

## 0.28.0

[Full diff](https://github.com/sider/runners/compare/0.27.0...0.28.0)

Updated environments:

- **devon_rex** 2.19.0 -> 2.20.0 [#1110](https://github.com/sider/runners/pull/1196) [#1204](https://github.com/sider/runners/pull/1204)

Updated tools:

- **Brakeman** 4.3.1 -> 4.8.2 [#1188](https://github.com/sider/runners/pull/1188)
- **Checkstyle** 8.32 -> 8.33 [#1162](https://github.com/sider/runners/pull/1162)
- **Cppcheck** 2.0 -> 2.1 [#1199](https://github.com/sider/runners/pull/1199)
- **cpplint** 1.4.5 -> 1.5.1 [#1175](https://github.com/sider/runners/pull/1175)
- **ESLint** 6.8.0 -> 7.2.0 [#1192](https://github.com/sider/runners/pull/1192)
- **Flake8** 3.8.1 -> 3.8.3 [#1127](https://github.com/sider/runners/pull/1127) [#1189](https://github.com/sider/runners/pull/1189)
- **hadolint** 1.17.6 -> 1.18.0 [#1177](https://github.com/sider/runners/pull/1177)
- **ktlint** 0.36.0 -> 0.37.2 [#1167](https://github.com/sider/runners/pull/1167) [#1186](https://github.com/sider/runners/pull/1186) [#1202](https://github.com/sider/runners/pull/1202)
- **PMD CPD** 6.23.0 -> 6.24.0 [#1157](https://github.com/sider/runners/pull/1157)
- **PMD Java** 6.23.0 -> 6.24.0 [#1123](https://github.com/sider/runners/pull/1123)
- **Pylint** 2.5.2 -> 2.5.3 [#1190](https://github.com/sider/runners/pull/1190)
- **Reek** 6.0.0 -> 6.0.1 [#1161](https://github.com/sider/runners/pull/1161)
- **RuboCop** 0.83.0 -> 0.85.1 [#1170](https://github.com/sider/runners/pull/1170)
- **stylelint** 13.4.1 -> 13.6.1 [#1168](https://github.com/sider/runners/pull/1168) [#1203](https://github.com/sider/runners/pull/1203)

Misc:

- **Cppcheck** Add `bug-hunting` option [#1166](https://github.com/sider/runners/pull/1166)
- **ESLint** Stop using `~/.eslintrc.*` [#1201](https://github.com/sider/runners/pull/1201)
- **PMD CPD** Analyze multiple languages by default [#1200](https://github.com/sider/runners/pull/1200)
- Drop deprecated Golint, Govet, and GoMetaLinter [#1164](https://github.com/sider/runners/pull/1164)
- Improve error and warning messages [#1195](https://github.com/sider/runners/pull/1195)

## 0.27.0

[Full diff](https://github.com/sider/runners/compare/0.26.0...0.27.0)

New supported:

- **PMD CPD** [#1122](https://github.com/sider/runners/pull/1122)
- **Pylint** Fix no file error [#1158](https://github.com/sider/runners/pull/1158)

## 0.26.0

[Full diff](https://github.com/sider/runners/compare/0.25.6...0.26.0)

New supported:

- **Pylint** [#1149](https://github.com/sider/runners/pull/1149)

## 0.25.6

[Full diff](https://github.com/sider/runners/compare/0.25.5...0.25.6)

- **remark-lint** Fix handling `fatal` output [#1156](https://github.com/sider/runners/pull/1156)

## 0.25.5

[Full diff](https://github.com/sider/runners/compare/0.25.4...0.25.5)

- Fix ignoring non ASCII filename [#1153](https://github.com/sider/runners/pull/1153)

## 0.25.4

[Full diff](https://github.com/sider/runners/compare/0.25.3...0.25.4)

- Generated ignoring file sometimes is missing [#1150](https://github.com/sider/runners/pull/1150)

## 0.25.3

[Full diff](https://github.com/sider/runners/compare/0.25.2...0.25.3)

- Use git-ls-files instead of git-check-ignore [#1148](https://github.com/sider/runners/pull/1148)

## 0.25.2

[Full diff](https://github.com/sider/runners/compare/0.25.1...0.25.2)

- Output trace more [#1145](https://github.com/sider/runners/pull/1145)
- Do not remove .git within #with_gitignore [#1147](https://github.com/sider/runners/pull/1147)

## 0.25.1

[Full diff](https://github.com/sider/runners/compare/0.25.0...0.25.1)

- Add `git-blame` failed exception [#1143](https://github.com/sider/runners/pull/1143)

## 0.25.0

[Full diff](https://github.com/sider/runners/compare/0.24.0...0.25.0)

- Fix "No space left" error on Git workspace [#1112](https://github.com/sider/runners/pull/1112)
- **GolangCI-Lint** Explicitly set `--timeout` [#1117](https://github.com/sider/runners/pull/1117)
- **Cppcheck** Add `addon` option [#1119](https://github.com/sider/runners/pull/1119)
- **Cppcheck** 1.90 -> 2.0 [#1083](https://github.com/sider/runners/pull/1083)
- Add exception classes for failed git-fetch and git-checkout [#1139](https://github.com/sider/runners/pull/1139)

## 0.24.0

[Full diff](https://github.com/sider/runners/compare/0.23.3...0.24.0)

Updated environments:

- **devon_rex** 2.18.0 -> 2.19.0 [#1110](https://github.com/sider/runners/pull/1110)

Updated tools:

- **stylelint** 13.3.3 -> 13.4.1 [#1108](https://github.com/sider/runners/pull/1108)
- **detekt** 1.8.0 -> 1.9.1 [#1098](https://github.com/sider/runners/pull/1098)
- **GolangCI-Lint** 1.26.0 -> 1.27.0 [#1096](https://github.com/sider/runners/pull/1096)
- **JSHint** 2.11.0 -> 2.11.1 [#1095](https://github.com/sider/runners/pull/1095)
- **Querly** 1.0.0 -> 1.1.0 [#1094](https://github.com/sider/runners/pull/1094)
- **Flake8** 3.7.9 -> 3.8.1 [#1090](https://github.com/sider/runners/pull/1090)
- **RuboCop** 0.82.0 -> 0.83.0 [#1089](https://github.com/sider/runners/pull/1089)

Misc:

- Bump typescript from 3.8.3 to 3.9.2
  - [#1097](https://github.com/sider/runners/pull/1097)
  - [#1093](https://github.com/sider/runners/pull/1093)
- Add :use_local not to attempt to fetch gems remotely [#1078](https://github.com/sider/runners/pull/1078)
- Add top-level `Bugsnag.notify` [#1086](https://github.com/sider/runners/pull/1086)

## 0.23.3

[Full diff](https://github.com/sider/runners/compare/0.23.2...0.23.3)

- **ESLint** Support v7 [#1072](https://github.com/sider/runners/pull/1072)

## 0.23.2

[Full diff](https://github.com/sider/runners/compare/0.23.1...0.23.2)

- **SwiftLint** Delete unchanged files [#1069](https://github.com/sider/runners/pull/1069)
- Ensure `Processor#analyzer` initialization [#1067](https://github.com/sider/runners/pull/1067)
- Add `analyzer` field to `Results::Error` [#1068](https://github.com/sider/runners/pull/1068)

## 0.23.1

[Full diff](https://github.com/sider/runners/compare/0.23.0...0.23.1)

- **SwiftLint** Improve error handling [#1063](https://github.com/sider/runners/pull/1063)
- Log issues count [#1064](https://github.com/sider/runners/pull/1064)

## 0.23.0

[Full diff](https://github.com/sider/runners/compare/0.22.4...0.23.0)

New supported:

- **LanguageTool** [#787](https://github.com/sider/runners/pull/787)

Updated environments:

- **Ruby** 2.6.6 -> 2.7.1 [#985](https://github.com/sider/runners/pull/985)
- **devon_rex** 2.16.1 -> 2.18.0 [#978](https://github.com/sider/runners/pull/978) [#1038](https://github.com/sider/runners/pull/1038) [#1057](https://github.com/sider/runners/pull/1057)

Updated tools:

- **Checkstyle** 8.30 -> 8.32 [#920](https://github.com/sider/runners/pull/920) [#1028](https://github.com/sider/runners/pull/1028)
- **detekt** 1.7.0 -> 1.8.0 [#986](https://github.com/sider/runners/pull/986)
- **FxCop** 2.9.8 -> 3.0.0 [#1020](https://github.com/sider/runners/pull/1020)
- **GolangCI-Lint** 1.24.0 -> 1.26.0 [#1023](https://github.com/sider/runners/pull/1023) [#1044](https://github.com/sider/runners/pull/1044)
- **Goodcheck** 2.5.0 -> 2.5.1 [#916](https://github.com/sider/runners/pull/916)
- **hadolint** 1.17.5 -> 1.17.6 [#1025](https://github.com/sider/runners/pull/1025)
- **PHP_CodeSniffer** 3.5.4 -> 3.5.5 [#1032](https://github.com/sider/runners/pull/1032)
- **PMD Java** 6.21.0 -> 6.23.0 [#922](https://github.com/sider/runners/pull/922) [#1029](https://github.com/sider/runners/pull/1029)
- **Reek** 5.6.0 -> 6.0.0 [#919](https://github.com/sider/runners/pull/919)
- **remark-lint** 7.0.1 -> 8.0.0 [#921](https://github.com/sider/runners/pull/921) [#926](https://github.com/sider/runners/pull/926)
  - Note that `remark-cli` is used as the main package [#1039](https://github.com/sider/runners/pull/1039)
- **RuboCop** 0.80.1 -> 0.82.0 [#972](https://github.com/sider/runners/pull/972)
- **ShellCheck** 0.7.0 -> 0.7.1 [#968](https://github.com/sider/runners/pull/968)
- **stylelint** 13.2.0 -> 13.3.3 [#990](https://github.com/sider/runners/pull/990)
- **SwiftLint** 0.39.1 -> 0.39.2 [#938](https://github.com/sider/runners/pull/938)
- **TSLint** 6.0.0 -> 6.1.2 [#1008](https://github.com/sider/runners/pull/1008)

Misc:

- Extend the deadline for deprecated Go tools [#1002](https://github.com/sider/runners/pull/1002)
- **Checkstyle** Shorten official issue ID [#1035](https://github.com/sider/runners/pull/1035)
- **FxCop** [roslyn-analyzers-runner](https://github.com/sider/roslyn-analyzers-runner) provides a static code analysis without running build [#971](https://github.com/sider/runners/pull/971)
- **GolangCI-Lint** Change default linters [#1001](https://github.com/sider/runners/pull/1001)
- **SwiftLint** Some improvements [#1005](https://github.com/sider/runners/pull/1005)
- **Misspell** Deprecate `targets` option [#1046](https://github.com/sider/runners/pull/1046)
- **Misspell** Some improvements [#1050](https://github.com/sider/runners/pull/1050)
- Remove ActiveSupport [#1054](https://github.com/sider/runners/pull/1054)

## 0.22.4

[Full diff](https://github.com/sider/runners/compare/0.22.3...0.22.4)

- Fix #patches and use ... for git-diff(1) [#955](https://github.com/sider/runners/pull/955)
- Fix Changes#include? to return false for unchanged files [#954](https://github.com/sider/runners/pull/954)
- Delete noisy warning on `npm install` [#957](https://github.com/sider/runners/pull/957)

## 0.22.3

[Full diff](https://github.com/sider/runners/compare/0.22.2...0.22.3)

## 0.22.2

[Full diff](https://github.com/sider/runners/compare/0.22.1...0.22.2)

- Fix Ignoring to support many files in the `ignore` configuration [#936](https://github.com/sider/runners/pull/936)
- \[remark-lint] More relax constraints [#943](https://github.com/sider/runners/pull/943)
- Bump devon_rex images from 2.16.0 to 2.16.1 [#945](https://github.com/sider/runners/pull/945)

## 0.22.1

[Full diff](https://github.com/sider/runners/compare/0.22.0...0.22.1)

- Bump devon_rex images from master to 2.16.0 [#892](https://github.com/sider/runners/pull/892)

## 0.22.0

[Full diff](https://github.com/sider/runners/compare/0.21.7...0.22.0)

- Improve warnings for Node.js runners [#844](https://github.com/sider/runners/pull/844)
- Use ASCII_8BIT to avoid ArgumentError for #scan [#845](https://github.com/sider/runners/pull/845)
- [remark-lint] New support [#813](https://github.com/sider/runners/pull/813)
- [Reek] Support new options [#863](https://github.com/sider/runners/pull/863)
- [cpplint] Bump cpplint from 1.4.4 to 1.4.5 [#869](https://github.com/sider/runners/pull/869)
- [GolangCI-Lint] Bump GolangCI-Lint from 1.23.6 to 1.24.0 [#871](https://github.com/sider/runners/pull/871)
- [hadolint] Bump hadolint from 1.17.4 to 1.17.5 [#872](https://github.com/sider/runners/pull/872)
- Show composer and composer packages' versions [#876](https://github.com/sider/runners/pull/876)
- [PHP_CodeSniffer] Deprecate `version` option [#878](https://github.com/sider/runners/pull/878)
- [PMD Java] Improve issues result [#880](https://github.com/sider/runners/pull/880)
- [detekt] Bump detekt-cli from 1.6.0 to 1.7.0 [#890](https://github.com/sider/runners/pull/890)

## 0.21.7

[Full diff](https://github.com/sider/runners/compare/0.21.6...0.21.7)

- Add Actions `on.push.tags` for `docker push` [#842](https://github.com/sider/runners/pull/842)

## 0.21.6

[Full diff](https://github.com/sider/runners/compare/0.21.5...0.21.6)

- Do not write the output of git-diff(1) [#837](https://github.com/sider/runners/pull/837)
- Normalize strings written to `TraceWriter` [#838](https://github.com/sider/runners/pull/838)

## 0.21.5

[Full diff](https://github.com/sider/runners/compare/0.21.4...0.21.5)

- Do not use base for git-blame(1) [#830](https://github.com/sider/runners/pull/830)

## 0.21.4

[Full diff](https://github.com/sider/runners/compare/0.21.3...0.21.4)

- Fix tagging for Docker images [#826](https://github.com/sider/runners/pull/826)

## 0.21.3

[Full diff](https://github.com/sider/runners/compare/0.21.2...0.21.3)

- Push Docker images with `master` tag [#825](https://github.com/sider/runners/pull/825)

## 0.21.2

[Full diff](https://github.com/sider/runners/compare/0.21.1...0.21.2)

- More kindful error message on invalid configuration [#818](https://github.com/sider/runners/pull/818)
- Add raw content of config file to trace [#819](https://github.com/sider/runners/pull/819)
- [SCSS-Lint] Add deprecation warning [#820](https://github.com/sider/runners/pull/820)

## 0.21.1

[Full diff](https://github.com/sider/runners/compare/0.21.0...0.21.1)

- [GolangCI-Lint] Warn no Go files instead of failing [#815](https://github.com/sider/runners/pull/815)
- Improve trace message on start and finish [#816](https://github.com/sider/runners/pull/816)

## 0.21.0

[Full diff](https://github.com/sider/runners/compare/0.20.0...0.21.0)

- Show stderr of git-blame(1) [#756](https://github.com/sider/runners/pull/756)
- [GolangCI-Lint] New support [#661](https://github.com/sider/runners/pull/661)
- [SwiftLint] Bump SwiftLint from 0.38.2 to 0.39.1 [#738](https://github.com/sider/runners/pull/738)
- [FxCop] New support [#731](https://github.com/sider/runners/pull/731)
- Aggregate log entries by `delete_unchanged_files` method [#765](https://github.com/sider/runners/pull/765)
- [RuboCop] Use `--out=FILE` option [#769](https://github.com/sider/runners/pull/769)
- [go-vet][Golint][Go Meta Linter] Add deprecated warning [#767](https://github.com/sider/runners/pull/767)
- [Goodcheck] Update goodcheck requirement from 2.4.5 to 2.5.0 [#775](https://github.com/sider/runners/pull/775)
- Add Runners::Config, which is responsible for sider.yml [#763](https://github.com/sider/runners/pull/763)
- [hadolint] Exclude template files by default [#780](https://github.com/sider/runners/pull/780)
- [TSLint] Add a deprecation warning [#783](https://github.com/sider/runners/pull/783)
- Whole `sider.yml` schema check [#750](https://github.com/sider/runners/issues/750)
- [detekt] New support [#749](https://github.com/sider/runners/pull/749)
- [TSLint] Bump typescript from 3.7.5 to 3.8.3 [#790](https://github.com/sider/runners/pull/790)
- [TyScan] Bump typescript from 3.7.5 to 3.8.3 [#791](https://github.com/sider/runners/pull/791)
- [Checkstyle] Bump checkstyle from 8.29 to 8.30 [#788](https://github.com/sider/runners/issues/788)
- [PHP_CodeSniffer] Bump wpcs from 2.2.0 to 2.2.1 [#789](https://github.com/sider/runners/issues/789)
- [PHPMD] Bump phpmd from 2.8.1 to 2.8.2 [#792](https://github.com/sider/runners/issues/792)
- [stylelint] Bump stylelint from 13.0.0 to 13.2.0 [#793](https://github.com/sider/runners/issues/793)
- Bump devon_rex images from 2.14.0 to 2.15.0 [#799](https://github.com/sider/runners/pull/799)
- Remove specified files via the `ignore` option [#798](https://github.com/sider/runners/pull/798)
- [HAML-Lint] Bump haml_lint from 0.34.2 to 0.35.0 [#794](https://github.com/sider/runners/pull/794)
- [RuboCop] Bump rubocop from 0.80.0 to 0.80.1 [#796](https://github.com/sider/runners/pull/796)

## 0.20.0

[Full diff](https://github.com/sider/runners/compare/0.19.4...0.20.0)

- [RuboCop] Update rubocop requirement from 0.79.0 to 0.80.0 [#752](https://github.com/sider/runners/pull/752)
- [HAML-Lint] Update rubocop requirement from 0.79.0 to 0.80.0 [#753](https://github.com/sider/runners/pull/753)
- [RuboCop] [HAML-Lint] Set an upper limit for constraints [#755](https://github.com/sider/runners/pull/755)

## 0.19.4

[Full diff](https://github.com/sider/runners/compare/0.19.3...0.19.4)

- Show Runners version and GUID to trace [#744](https://github.com/sider/runners/pull/744)

## 0.19.3

[Full diff](https://github.com/sider/runners/compare/0.19.2...0.19.3)

- [RuboCop] Add `gitlab-styles` to optional gem list [#743](https://github.com/sider/runners/pull/743)

## 0.19.2

[Full diff](https://github.com/sider/runners/compare/0.19.1...0.19.2)

- Add more plugins to OPTIONAL_GEMS in haml_lint.rb [#734](https://github.com/sider/runners/pull/734)

## 0.19.1

[Full diff](https://github.com/sider/runners/compare/0.19.0...0.19.1)

- Set UserKnownHostsFile to avoid error message [#730](https://github.com/sider/runners/pull/730)

## 0.19.0

[Full diff](https://github.com/sider/runners/compare/0.18.1...0.19.0)

- [RuboCop] Add more plugins to OPTIONAL_GEMS [#683](https://github.com/sider/runners/pull/683)
- [Flake8] Add warnings if the analysis tries to use Python 2 [#702](https://github.com/sider/runners/pull/702)
- [SwiftLint] Bump SwiftLint from 0.38.1 to 0.38.2 [#669](https://github.com/sider/runners/pull/669)
- [HAML-Lint] Bump rubocop-rails from 2.4.1 to 2.4.2 [#680](https://github.com/sider/runners/pull/680)
- [Checkstyle][Security] Bump checkstyle from 8.28 to 8.29 [#685](https://github.com/sider/runners/pull/685)
- [PHP_CodeSniffer] Bump squizlabs/php_codesniffer from 3.5.3 to 3.5.4 [#686](https://github.com/sider/runners/pull/686)
- [PHP_CodeSniffer] Bump escapestudios/symfony2-coding-standard from 3.10.0 to 3.11.0 [#688](https://github.com/sider/runners/pull/688)
- [TSLint] Bump typescript from 3.7.4 to 3.7.5 [#681](https://github.com/sider/runners/pull/691)
- [TyScan] Bump typescript from 3.7.4 to 3.7.5 [#692](https://github.com/sider/runners/pull/692)
- [PMD Java] Bump pmd-java from 6.20.0 to 6.21.0 [#695](https://github.com/sider/runners/pull/695)
- [Reek] Update reek requirement from 5.5.0 to 5.6.0 [#694](https://github.com/sider/runners/pull/694)
- [JSHint] Bump jshint from 2.10.3 to 2.11.0 [#690](https://github.com/sider/runners/pull/690)
- [stylelint] Bump stylelint from 12.0.1 to 13.0.0 [#693](https://github.com/sider/runners/pull/693)
- [TSLint] Bump tslint from 5.20.1 to 6.0.0 [#689](https://github.com/sider/runners/pull/689)
- [HAML-Lint] Update haml_lint requirement from 0.34.1 to 0.34.2 [#705](https://github.com/sider/runners/pull/705)
- [ESLint] Drop older versions of ESLint [#721](https://github.com/sider/runners/pull/721)
- [RuboCop] Drop older versions of RuboCop [#726](https://github.com/sider/runners/pull/726)
- Bump devon_rex images from 2.12.0 to 2.14.0 [#727](https://github.com/sider/runners/pull/727)
- [HAML-Lint] Update rubocop-rspec requirement from 1.37.1 to 1.38.0 [#720](https://github.com/sider/runners/pull/720)

## 0.18.1

[Full diff](https://github.com/sider/runners/compare/0.18.0...0.18.1)

- [TSLint] Loosen the version constraint allowing v6 [#681](https://github.com/sider/runners/pull/681)

## 0.18.0

[Full diff](https://github.com/sider/runners/compare/0.17.1...0.18.0)

- [hadolint] New support [#625](https://github.com/sider/runners/pull/625)

## 0.17.1

[Full diff](https://github.com/sider/runners/compare/0.17.0...0.17.1)

- Handle the empty externalInfoUrl in phpmd [#657](https://github.com/sider/runners/pull/657)
- Add #add_git_blame_info [#655](https://github.com/sider/runners/pull/655)

## 0.17.0

[Full diff](https://github.com/sider/runners/compare/0.16.0...0.17.0)

- [Brakeman] Quiet output [#647](https://github.com/sider/runners/pull/647)
- Bump devon_rex images from 2.11.0 to 2.12.0 [#646](https://github.com/sider/runners/pull/646)
- Bump Cppcheck from 1.89 to 1.90 [#628](https://github.com/sider/runners/pull/628)
- [HAML-Lint] Bump rubocop-rails from 2.4.0 to 2.4.1 [#629](https://github.com/sider/runners/pull/629)
- Bump checkstyle from 8.27 to 8.28 in /images/checkstyle [#635](https://github.com/sider/runners/pull/635)
- Bump typescript from 3.7.2 to 3.7.4 in /images/tyscan [#636](https://github.com/sider/runners/pull/636)
- Bump typescript from 3.7.2 to 3.7.4 in /images/tslint [#640](https://github.com/sider/runners/pull/640)
- Bump ktlint from 0.35.0 to 0.36.0 in /images/ktlint [#638](https://github.com/sider/runners/pull/638)
- Bump eslint from 6.7.2 to 6.8.0 in /images/eslint [#637](https://github.com/sider/runners/pull/637)
- Bump phpmd/phpmd from 2.7.0 to 2.8.1 in /images/phpmd [#641](https://github.com/sider/runners/pull/641)
- Bump stylelint from 12.0.0 to 12.0.1 in /images/stylelint [#639](https://github.com/sider/runners/pull/639)
- Bump php_codesniffer from 3.5.2 to 3.5.3 in /images/code_sniffer [#642](https://github.com/sider/runners/pull/642)
- Bump SwiftLint from 0.38.0 to 0.38.1 [#645](https://github.com/sider/runners/pull/645)
- [HAML-Lint] Bump rubocop from 0.78.0 to 0.79.0 [#650](https://github.com/sider/runners/pull/650)
- Bump rubocop from 0.78.0 to 0.79.0 in /images/rubocop [#651](https://github.com/sider/runners/pull/651)

## 0.16.0

[Full diff](https://github.com/sider/runners/compare/0.15.0...0.16.0)

- Add git_blame_info field in the Issue schema [#630](https://github.com/sider/runners/pull/630)

## 0.15.0

[Full diff](https://github.com/sider/runners/compare/0.14.0...0.15.0)

- Renewal trace [#624](https://github.com/sider/runners/pull/624)

## 0.14.0

[Full diff](https://github.com/sider/runners/compare/0.13.2...0.14.0)

- [HAML-Lint] Bump rubocop-rspec from 1.37.0 to 1.37.1 [#601](https://github.com/sider/runners/pull/601)
- [HAML-Lint] Bump rubocop from 0.77.0 to 0.78.0 [#613](https://github.com/sider/runners/pull/613)
- Bump rubocop from 0.77.0 to 0.78.0 [#608](https://github.com/sider/runners/pull/608)

## 0.13.2

[Full diff](https://github.com/sider/runners/compare/0.13.1...0.13.2)

- Truncate long message on trace [#605](https://github.com/sider/runners/pull/605)

## 0.13.1

[Full diff](https://github.com/sider/runners/compare/0.13.0...0.13.1)

- [Flake8] Fix error if `.python-version` file exists [#602](https://github.com/sider/runners/pull/602)

## 0.13.0

[Full diff](https://github.com/sider/runners/compare/0.12.0...0.13.0)

- Bump jshint from 2.10.2 to 2.10.3 [#543](https://github.com/sider/runners/pull/543)
- Bump pmd-java from 6.19.0 to 6.20.0 [#539](https://github.com/sider/runners/pull/539)
- Bump checkstyle from 8.26 to 8.27 [#540](https://github.com/sider/runners/pull/540)
- Bump reek from 5.4.0 to 5.5.0 [#541](https://github.com/sider/runners/pull/541)
- Bump symfony2-coding-standard from 3.9.2 to 3.10.0 [#542](https://github.com/sider/runners/pull/542)
- Bump eslint from 6.6.0 to 6.7.2 [#544](https://github.com/sider/runners/pull/544)
- Bump wpcs from 2.1.1 to 2.2.0 [#546](https://github.com/sider/runners/pull/546)
- Bump cakephp-codesniffer from 3.1.2 to 3.3.0 [#561](https://github.com/sider/runners/pull/561)
- Bump SwiftLint from 0.37.0 to 0.38.0 [#557](https://github.com/sider/runners/pull/557)
- [PMD Java] Find design issues by default [#563](https://github.com/sider/runners/pull/563)
- [PMD Java] Save issue details [#565](https://github.com/sider/runners/pull/565)
- [Reek] Improve issue message [#566](https://github.com/sider/runners/pull/566)
- [HAML-Lint] Save issue link and severity [#567](https://github.com/sider/runners/pull/567)
- Bump devon_rex images from 2.10.0 to master [#568](https://github.com/sider/runners/pull/568)
- Bump devon_rex images from master to 2.11.0 [#578](https://github.com/sider/runners/pull/578)
- Show runtime version as possible [#575](https://github.com/sider/runners/pull/575)
- Bump haml_lint from 0.34.0 to 0.34.1 [#576](https://github.com/sider/runners/pull/576)
- [PHPMD] Output report to file instead of STDOUT [#577](https://github.com/sider/runners/pull/577)
- Filter issues with the "diff lines" [#584](https://github.com/sider/runners/pull/584)
- [PHPMD] Reduce trace size [#588](https://github.com/sider/runners/pull/588)
- [PHPMD] Handle invalid output XML [#589](https://github.com/sider/runners/pull/589)
- [HAML-Lint] Add warnings if RuboCop fails [#587](https://github.com/sider/runners/pull/587)
- Bump goodcheck from 2.4.4 to 2.4.5 [#591](https://github.com/sider/runners/pull/591)
- Hide userinfo of HTTP URI from the traces [#585](https://github.com/sider/runners/pull/585)
- [PHPCS] Empower runner [#592](https://github.com/sider/runners/pull/592)
- Use Yarn when duplicate lock files are found [#593](https://github.com/sider/runners/pull/593)

## 0.12.0

[Full diff](https://github.com/sider/runners/compare/0.11.1...0.12.0)

- Add Workspace::Git to fetch source code via Git [#548](https://github.com/sider/runners/pull/548)

## 0.11.1

[Full diff](https://github.com/sider/runners/compare/0.11.0...0.11.1)

- Add a feature to mask secure strings on TraceWriter [#537](https://github.com/sider/runners/pull/537)
- [ShellCheck] No warnings when no analyzed files [#538](https://github.com/sider/runners/pull/538)

## 0.11.0

[Full diff](https://github.com/sider/runners/compare/0.10.0...0.11.0)

- Bump devon_rex images from 2.9.0 to 2.10.0 [#527](https://github.com/sider/runners/pull/527)
- [HAML-Lint] Fix incompatibility with RuboCop [#533](https://github.com/sider/runners/pull/533)
- [RuboCop] Bump rubocop from 0.76.0 to 0.77.0 [#529](https://github.com/sider/runners/pull/529)
- [HAML-Lint] Bump rubocop from 0.76.0 to 0.77.0 [#530](https://github.com/sider/runners/pull/530)
- [HAML-Lint] Bump rubocop-rspec from 1.36.0 to 1.37.0 [#531](https://github.com/sider/runners/pull/531)
- [HAML-Lint] Bump rubocop-rails from 2.3.2 to 2.4.0 [#532](https://github.com/sider/runners/pull/532)
- Configure instance_profile_credentials_* for Aws::S3::Client [#526](https://github.com/sider/runners/pull/526)
- [RuboCop] Bump Ruby from 2.5.6 to 2.5.7 [#534](https://github.com/sider/runners/pull/534)
- [cpplint] Fix error when the output line number is `None` [#536](https://github.com/sider/runners/pull/536)

## 0.10.0

[Full diff](https://github.com/sider/runners/compare/0.9.2...0.10.0)

- Bump devon_rex images from 2.8.0 to 2.9.0 [#500](https://github.com/sider/runners/pull/500)
- Wrap Workspace with Harness [#501](https://github.com/sider/runners/pull/501)
- Bump goodcheck from 2.4.3 to 2.4.4 [#505](https://github.com/sider/runners/pull/505)
- Mark the result "failure" when `sider.yml` is broken [#504](https://github.com/sider/runners/pull/504)
- Bump stylelint from 11.1.1 to 12.0.0 [#508](https://github.com/sider/runners/pull/508)

## 0.9.2

[Full diff](https://github.com/sider/runners/compare/0.9.1...0.9.2)

- Flush content whenever its size reaches the buffer max limit [#497](https://github.com/sider/runners/pull/497)

## 0.9.1

[Full diff](https://github.com/sider/runners/compare/0.9.0...0.9.1)

- [RuboCop] Fix `Ruby#installed_gem_versions` [#489](https://github.com/sider/runners/pull/489)

## 0.9.0

[Full diff](https://github.com/sider/runners/compare/0.8.2...0.9.0)

- Update scss_lint from 0.58.0 to 0.59.0 [#432](https://github.com/sider/runners/pull/432)
- Bump pmd_java from 6.18.0 to 6.19.0 [#433](https://github.com/sider/runners/pull/433)
- Bump flake8 from 3.7.8 to 3.7.9 [#436](https://github.com/sider/runners/pull/436)
- Bump haml_lint from 0.33.0 to 0.34.0 [#440](https://github.com/sider/runners/pull/440)
- Bump checkstyle from 8.25 to 8.26 [#441](https://github.com/sider/runners/pull/441)
- Bump ktlint from 0.34.2 to 0.35.0 [#442](https://github.com/sider/runners/pull/442)
- Bump php_codesniffer from 3.5.0 to 3.5.2 [#444](https://github.com/sider/runners/pull/444)
- Bump tslint from 5.20.0 to 5.20.1 [#469](https://github.com/sider/runners/pull/469)
- Bump eslint from 6.5.1 to 6.6.0 [#431](https://github.com/sider/runners/pull/431)
- Bump goodcheck from 2.4.0 to 2.4.3 [#468](https://github.com/sider/runners/pull/468)
- Bump rubocop from 0.75.0 to 0.76.0 [#434](https://github.com/sider/runners/pull/434)
- Bump devon_rex images from 2.7.0 to 2.8.0 [#474](https://github.com/sider/runners/pull/474)
- Bump SwiftLint from 0.36.0 to 0.37.0 [#473](https://github.com/sider/runners/pull/473)
- [RuboCop] Empower runner [#472](https://github.com/sider/runners/pull/472)
- [checkstyle] Empower runner [#475](https://github.com/sider/runners/pull/475)
- [SwiftLint] Show a warning when no linting files [#478](https://github.com/sider/runners/pull/478)
- Bump JavaSee from 0.1.2 to 0.1.3 [#479](https://github.com/sider/runners/pull/479)
- Bump stylelint from 11.0.0 to 11.1.1 [#438](https://github.com/sider/runners/pull/438)
- [Cppcheck] Show warning and succeed when no linting files [#480](https://github.com/sider/runners/pull/480)
- Deprecate `linter.*.options` option [#482](https://github.com/sider/runners/pull/482)

## 0.8.2

[Full diff](https://github.com/sider/runners/compare/0.8.1...0.8.2)

- Add Runners version and set it to result [#449](https://github.com/sider/runners/pull/449)
- Always output the exit status to trace [#451](https://github.com/sider/runners/pull/451)
- Configure :endpoint if S3_ENDPOINT is set [#462](https://github.com/sider/runners/pull/462)

## 0.8.1

[Full diff](https://github.com/sider/runners/compare/0.8.0...0.8.1)

- [ESLint] Fix type error when no location info [#456](https://github.com/sider/runners/pull/456)

## 0.8.0

[Full diff](https://github.com/sider/runners/compare/0.7.5...0.8.0)

- Bugsnag notify on `rescue` block [#445](https://github.com/sider/runners/pull/445)
- [stylelint] Empower runner [#420](https://github.com/sider/runners/pull/420)
- [cpplint] New support [#417](https://github.com/sider/runners/pull/417)
- **[BREAKING]** Add Options module and delete insecure options [#415](https://github.com/sider/runners/pull/415)
- Output an unexpected error message to the trace log [#446](https://github.com/sider/runners/pull/446)
- [ESLint] Use `--output-file` option to fix JSON parse error [#447](https://github.com/sider/runners/pull/447)
- Suppress `npm ls` output [#448](https://github.com/sider/runners/pull/448)

## 0.7.5

[Full diff](https://github.com/sider/runners/compare/0.7.4...0.7.5)

- Improve deprecation message for older versions [#419](https://github.com/sider/runners/pull/419)
- [SwiftLint] Treat as success when no linting files [#422](https://github.com/sider/runners/pull/422)
- [JSHint] Improve error message when output XML parse is failed [#423](https://github.com/sider/runners/pull/423)

## 0.7.4

[Full diff](https://github.com/sider/runners/compare/0.7.3...0.7.4)

- Report message and metadata on `Shell::ExecError` to Bugsnag [#414](https://github.com/sider/runners/pull/414)
- Fix error for issue sorting when location is nil [#416](https://github.com/sider/runners/pull/416)

## 0.7.3

[Full diff](https://github.com/sider/runners/compare/0.7.2...0.7.3)

- Remove a warning for Node.js analyzers without dependencies [#410](https://github.com/sider/runners/pull/410)

## 0.7.2

[Full diff](https://github.com/sider/runners/compare/0.7.1...0.7.2)

- [JSHint] Show runtime versions [#407](https://github.com/sider/runners/pull/407)
- Copy `ARGV` for notifying to Bugsnag correctly [#408](https://github.com/sider/runners/pull/408)

## 0.7.1

[Full diff](https://github.com/sider/runners/compare/0.7.0...0.7.1)

- Set Bugsnag `release_stage` explicitly [#404](https://github.com/sider/runners/pull/404)
- Improve Bugsnag settings [#405](https://github.com/sider/runners/pull/405)
- [ESLint] Allow `recommended` as string [#406](https://github.com/sider/runners/pull/406)

## 0.7.0

[Full diff](https://github.com/sider/runners/compare/0.6.0...0.7.0)

- [JSHint] Consider broken package.json [#327](https://github.com/sider/runners/pull/327)
- Bump devon_rex images from master to 2.6.0 and bump Ruby from 2.6.4 to 2.6.5 [#332](https://github.com/sider/runners/pull/332)
- Trap SIGTERM to exit with an arbitrary status [#344](https://github.com/sider/runners/pull/344)
- Bump JavaSee from 0.1.1 to 0.1.2 [#362](https://github.com/sider/runners/pull/362)
- Optimize generated Gemfile [#359](https://github.com/sider/runners/pull/359)
- Use `COPY --chown` format in Dockerfile [#369](https://github.com/sider/runners/pull/369)
- Use pre-installed gems as possible [#367](https://github.com/sider/runners/pull/367)
- Bump SwiftLint from 0.34.0 to 0.36.0 [#363](https://github.com/sider/runners/pull/363)
- Bump devon_rex images from 2.6.0 to 2.7.0 (many PRs!)
- Empower ESLint runner [#401](https://github.com/sider/runners/pull/401)

## 0.6.0

[Full diff](https://github.com/sider/runners/compare/0.5.2...0.6.0)

- Reconsider issue data structure [#313](https://github.com/sider/runners/pull/313)
- Fix PHPMD target files with `suffixes` option [#318](https://github.com/sider/runners/pull/318)
- Fix Checkstyle output XML parse error [#319](https://github.com/sider/runners/pull/319)
- Improve Goodcheck error message [#321](https://github.com/sider/runners/pull/321)
- Improve Checkstyle invalid XML error message [#322](https://github.com/sider/runners/pull/322)
- Improve PHPMD custom rule support [#323](https://github.com/sider/runners/pull/323)
- Make timeout(1) call SIGUSR2 and trap it in bin/runners [#320](https://github.com/sider/runners/pull/320)
- Bump devon_rex images from 2.4.0 to 2.5.0 [#324](https://github.com/sider/runners/pull/324)

## 0.5.2

[Full diff](https://github.com/sider/runners/compare/0.5.1...0.5.2)

- Notify exception if the result is "error" [#312](https://github.com/sider/runners/pull/312)
- Set ConnectTimeout for ssh(1) to avoid waiting for a long time [#309](https://github.com/sider/runners/pull/309)

## 0.5.1

[Full diff](https://github.com/sider/runners/compare/0.5.0...0.5.1)

- Add Bugsnag to notify any errors [#304](https://github.com/sider/runners/pull/304)
- Use timeout(1) to forcefully terminate too late Runners [#306](https://github.com/sider/runners/pull/306)

## 0.5.0

[Full diff](https://github.com/sider/runners/compare/0.4.1...0.5.0)

- Add ShellCheck runner [#289](https://github.com/sider/runners/pull/289)
- Install PHP_CodeSniffer and its dependencies via Composer [#290](https://github.com/sider/runners/pull/290)
- Bump phpmd/phpmd from 2.6.1 to 2.7.0 [#291](https://github.com/sider/runners/pull/291)
- Bump escapestudios/symfony2-coding-standard from 3.4.1 to 3.9.2 [#292](https://github.com/sider/runners/pull/292)
- Bump cakephp/cakephp-codesniffer from 3.1.1 to 3.1.2 [#293](https://github.com/sider/runners/pull/293)
- Bump wp-coding-standards/wpcs from 2.0.0 to 2.1.1 [#294](https://github.com/sider/runners/pull/294)
- Bump squizlabs/php_codesniffer from 3.4.2 to 3.5.0 [#295](https://github.com/sider/runners/pull/295)
- Bump all devon_rex images from 2.3.1 to 2.4.0 (see [changelog](https://github.com/sider/devon_rex/blob/master/CHANGELOG.md#240))

## 0.4.1

[Full diff](https://github.com/sider/runners/compare/0.4.0...0.4.1)

- Retrieve --head, --head-key, --base, and --base-key from env [#249](https://github.com/sider/runners/pull/249)

## 0.4.0

[Full diff](https://github.com/sider/runners/compare/0.3.1...0.4.0)

- Update eslint requirement from 5.16.0 to 6.4.0 [#100](https://github.com/sider/runners/pull/100)
- Show deprecation warning for too old ESLint [#209](https://github.com/sider/runners/pull/209)
- Update tslint requirement from 5.18.0 to 5.20.0 [#101](https://github.com/sider/runners/pull/101)
- Update typescript requirement from 3.5.3 to 3.6.3 [#104](https://github.com/sider/runners/pull/104)
- Bump default stylelint and stylelint-config-recommended [#210](https://github.com/sider/runners/pull/210)
- Add `.npmrc` for common settings [#211](https://github.com/sider/runners/pull/211)
- Update rubocop-rspec from 1.33.0 to 1.35.0 for HAML-Lint [#116](https://github.com/sider/runners/pull/116)
- Update typescript from 3.5.3 to 3.6.3 for TyScan [#103](https://github.com/sider/runners/pull/103)
- Update sass from 3.7.3 to 3.7.4 for rails_best_practices [#117](https://github.com/sider/runners/pull/117)
- Update scss_lint from 0.57.1 to 0.58.0 [#121](https://github.com/sider/runners/pull/121)
- Update rubocop from 0.71.0 to 0.74.0 for haml_lint [#115](https://github.com/sider/runners/pull/115)
- Update sassc from 2.0.1 to 2.2.1 for rails_best_practices [#119](https://github.com/sider/runners/pull/119)
- Bump flake8 from 3.7.7 to 3.7.8 [#124](https://github.com/sider/runners/pull/124)
- Update haml from 5.0.4 to 5.1.2 for rails_best_practices [#120](https://github.com/sider/runners/pull/120)
- Update haml_lint from 0.32.0 to 0.33.0 [#118](https://github.com/sider/runners/pull/118)
- Update tyscan from 0.2.1 to 0.3.1 [#212](https://github.com/sider/runners/pull/212)
- Bump checkstyle from 8.23 to 8.25 [#221](https://github.com/sider/runners/pull/221)
- Add "security" to the default rulesets of PMD Java [#226](https://github.com/sider/runners/pull/226)
- Bump pmd-java from 6.17.0 to 6.18.0 [#225](https://github.com/sider/runners/pull/225)
- Show Java runtime versions for Java based tools [#227](https://github.com/sider/runners/pull/227)
- Receive an SSH key with an environment variable [#206](https://github.com/sider/runners/pull/206)
- Add deprecation warning for too old RuboCop versions [#228](https://github.com/sider/runners/pull/228)
- Update rubocop-rails from 2.0.1 to 2.3.2 for haml_lint [#232](https://github.com/sider/runners/pull/232)
- Update rubocop-rspec from 1.35.0 to 1.36.0 for haml_lint [#233](https://github.com/sider/runners/pull/233)
- Update rubocop from 0.74.0 to 0.75.0 for haml_lint [#236](https://github.com/sider/runners/pull/236)
- Bump default eslint from 6.4.0 to 6.5.1 [#235](https://github.com/sider/runners/pull/235)
- Bump devon_rex images to 2.3.1 [#244](https://github.com/sider/runners/pull/244)
- Bump rubocop from 0.74.0 to 0.75.0 [#229](https://github.com/sider/runners/pull/229)
- Extend `limit` option of `TraceWriter#message` [#1036](https://github.com/sider/runners/pull/1036)

## 0.3.1

[Full diff](https://github.com/sider/runners/compare/0.3.0...0.3.1)

- Make #presence available [#204](https://github.com/sider/runners/pull/204)

## 0.3.0

[Full diff](https://github.com/sider/runners/compare/0.2.1...0.3.0)

- Add IO::AwsS3 to upload traces to AWS S3 [#162](https://github.com/sider/runners/pull/162)
- Fix ktlint bug [#201](https://github.com/sider/runners/pull/201)

## 0.2.1

[Full diff](https://github.com/sider/runners/compare/0.2.0...0.2.1)

- Fix missing ktlint settings in CircleCI [#198](https://github.com/sider/runners/pull/198)
- Fix ktlint bug [#201](https://github.com/sider/runners/pull/201)

## 0.2.0

[Full diff](https://github.com/sider/runners/compare/0.1.0...0.2.0)

- Fix `npm install` for TyScan [#163](https://github.com/sider/runners/pull/163)
- Support ktlint [#192](https://github.com/sider/runners/pull/192)
- Optimize Cppcheck Docker image via multi-stage [#195](https://github.com/sider/runners/pull/195)
- Bump devon_rex images from 2.2.0 to 2.2.2 (thanks to Dependabot!)

## 0.1.0

[Full diff](https://github.com/sider/runners/compare/0.0.7...0.1.0)

- Rename namespace: `NodeHarness` -> `Runners` [#96](https://github.com/sider/runners/pull/96)
- Install default npm tools via `package.json` [#99](https://github.com/sider/runners/pull/99)
- Set Bundler config: `jobs`, `retry` [#107](https://github.com/sider/runners/pull/107)
- Change owner and group of runner's home directory [#109](https://github.com/sider/runners/pull/109)
- Remove useless `BUNDLE_GEMFILE` from `Dockerfile` [#122](https://github.com/sider/runners/pull/122)
- Install default gems via `Gemfile` [#110](https://github.com/sider/runners/pull/110)
- Use Pipenv to address the dependency of Flake8 [#111](https://github.com/sider/runners/pull/111)
- Normalize version strings of Go tools [#123](https://github.com/sider/runners/pull/123)

## 0.0.7

[Full diff](https://github.com/sider/runners/compare/0.0.6...0.0.7)

- Show Node.js runtime versions [#83](https://github.com/sider/runners/pull/83)
- Improve error message when `root_dir` is not found [#84](https://github.com/sider/runners/pull/84)
- Improve messages in markdown format [#85](https://github.com/sider/runners/pull/85)
- Show Ruby runtime versions [#87](https://github.com/sider/runners/pull/87)
- Bump devon_rex images from 2.1.0 to 2.2.0 [#89](https://github.com/sider/runners/pull/89)
- Fix `stylelint-config-recommended` version [#93](https://github.com/sider/runners/pull/93)

## 0.0.6

[Full diff](https://github.com/sider/runners/compare/0.0.5...0.0.6)

- Bump devon_rex images from 2.0.3 to 2.1.0 [#75](https://github.com/sider/runners/pull/75)
