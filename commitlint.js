// Based on @commitlint/config-conventional

module.exports = {
    rules: {
      // Commit body must starts from empty line
      "body-leading-blank": [2, "always"],
  
      // Bottom colontitle must starts from empty line
      "footer-leading-blank": [2, "always"],
  
      // Max title length is 72 chars
      "header-max-length": [2, "always", 72],
  
      // Code scope always in lower case
      "scope-case": [2, "always", "lower-case"],
  
      // Description can be empty
      "subject-empty": [2, "never"],
  
      // Description must ends with '.'
      "subject-full-stop": [2, "never", "."],
  
      // Type always in lower case
      "type-case": [2, "always", "lower-case"],
  
      // Type cannot be empty
      "type-empty": [2, "never"],
  
      // List of all allowed commit types
      "type-enum": [
        2,
        "always",
        [
          "build",
          "ci",
          "docs",
          "feat",
          "fix",
          "perf",
          "refactor",
          "revert",
          "style",
          "test"
        ]
      ]
    }
  };