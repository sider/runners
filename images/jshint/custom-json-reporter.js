"use strict";

// https://github.com/jshint/jshint/blob/2.13.0/src/reporters/checkstyle.js#L45-L55
const SEVERITY = Object.freeze({
  I: "info",
  W: "warning",
  E: "error",
});

// https://jshint.com/docs/reporters/
module.exports = {
  reporter(results) {
    const issues = results.map((result) => {
      const error = result.error;
      return {
        file: result.file,
        code: error.code,
        message: error.reason,
        line: error.line,
        column: error.character,
        severity: SEVERITY[error.code.charAt(0)],
      };
    });

    console.log(JSON.stringify({ issues }));
  },
};
