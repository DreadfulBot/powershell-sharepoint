"use strict";

module.exports = {
  types: [
    {
      value: "build",
      name: "build:     Project build or dependencies changing"
    },
    { value: "ci", name: "ci:        CI setup and scripts work" },
    { value: "docs", name: "docs:      Documentation update" },
    { value: "feat", name: "feat:      New Features" },
    { value: "fix", name: "fix:       Bugfix" },
    {
      value: "perf",
      name: "perf:      Performance improvements"
    },
    {
      value: "refactor",
      name:
        "refactor:  Refactor works without adding new improvements and bugfixes"
    },
    { value: "revert", name: "revert:    Rollback to previous commits" },
    {
      value: "style",
      name:
        "style:     Styleguide code fixes (tabs, spaces, dots, commas, etc...)"
    },
    { value: "test", name: "test:      Adding tests" }
  ],

  // Scope. It describes code fragment that was changed
  scopes: [
    { name: "components" },
    { name: "tutorial" },
    { name: "catalog" },
    { name: "product" }
  ],

  // It is possible to set SCOPE for specific commit type (for example, for 'fix')
  /*
  scopeOverrides: {
    fix: [
      {name: 'style'},
      {name: 'e2eTest'},
      {name: 'unitTest'}
    ]
  },
  */

  // Default questions override
  messages: {
    type: "What type of changes are you making?",
    scope: "\nSet affected SCOPE (optional):",
    // Asking if allowCustomScopes = true
    customScope: "Set SCOPE:",
    subject: "Write SHORT description of changes in IMMEDIATE mood:\n",
    body:
      'Write LONG description (optional). User "|" for new line and carret return:\n',
    breaking: "List of BREAKING CHANGES (optional):\n",
    footer:
      "Placeholder for metadata (tickets, links, etc...). Example: SECRETMRKT-700, SECRETMRKT-800:\n",
    confirmCommit: "Do you approve created commit?"
  },

  // Allow custom SCOPE
  allowCustomScopes: true,

  // Deny breaking changes
  allowBreakingChanges: false,

  // Prefix for bottom colontitle
  footerPrefix: "META DATA:",

  // limit subject length
  subjectLimit: 72
};