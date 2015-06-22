# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

## [0.3.0] - 2015-06-21
### Added
- Fully customized response of the JIRA issue via templates. See the extensive
  [documentation](https://github.com/amaltson/lita-jira-issues#customize-output)
  on how to customize the formatting. Huge thanks to @hickey for the
  contribution.

## [0.2.3] - 2015-04-29
### Added
- Optional TTL feature for silencing the same JIRA for a period of time. Thanks
to @johntdyer for the contribution.

## [0.2.2] - 2015-04-11
### Added
- A mechanism to ignore a list of users. Thanks to @jlambert121 for contributing.

## [0.2.1] - 2014-11-20
### Fixes
- Display mentioned JIRA issue only once, not each time the issue is mentioned.

## [0.2.0] - 2014-10-30
### Changed
- Upgrade to Lita 4, handler will only work with Lita 4 from this version on.

## [0.1.0] - 2014-10-30
### Added
- Initial release. Handler to output JIRA issue information when a JIRA key is
  mentioned.
- This plugin is inspired by the [Hubot jira-issue plugin](
  https://github.com/github/hubot-scripts/blob/master/src/scripts/jira-issues.coffee)


[unreleased]: https://github.com/amaltson/lita-jira-issues/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/amaltson/lita-jira-issues/compare/v0.2.3...v0.3.0
[0.2.3]: https://github.com/amaltson/lita-jira-issues/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/amaltson/lita-jira-issues/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/amaltson/lita-jira-issues/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/amaltson/lita-jira-issues/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/amaltson/lita-jira-issues/compare/0b10b90...v0.1.0
