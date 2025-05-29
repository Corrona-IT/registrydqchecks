# **2025-05-20 Update**

**Bug fixes**
- Updated underlying CC6 code to appropriately list rows removed from last month to this month.
  - Issue: https://github.com/Corrona-IT/registrydqchecks/issues/119
  - Commit: https://github.com/Corrona-IT/registrydqchecks/commit/593fe546f570959706539ba753634dec42d9a763


# **2025-05-16 Update**

**Feature Additions**
- Added function to check the input parameters of the [runRegistryChecks](https://github.com/Corrona-IT/registrydqchecks/blob/main/R/02_parameterCheck.R) function - this function stops the execution of runRegistryChecks and prints a message to the console if any of the input parameters are incorrect or point to unavailable folders or files

- Added functions [open_sink](https://github.com/Corrona-IT/registrydqchecks/blob/main/R/13_open_sink.R) and [close_sink](https://github.com/Corrona-IT/registrydqchecks/blob/main/R/14_close_sink.R) to capture and output the console messages/notes/warnings into a .txt document into the same folder as the HTML report output every time the report is run
  - Added these function to registry-specific code to capture and output the console messages
 
**Report Updates**
- Add URLs of current and past month data folders to the runner summary in the HTML report
- Reordered the NC21 output table to sort by the largest absolute percent change - with largest change being at the top of the table
- Added wording to delimit a Registry Check from a Noncritical Check in the HTML report - Any check with an ID of "rc##" will now be displayed as Registry Check in the report

