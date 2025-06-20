# **2025-06-16 Update**

**Feature Additions**
- Add [data_changes](https://github.com/Corrona-IT/registrydqchecks/blob/main/R/03_data_changes.R) as an exported function to be used ad hoc. This function takes in 2 datasets and does a complete comparison on them - outputting an Excel file. Decision was made not to include this in the runRegistryChecks function by default due to large datasets taking a lot of time to run. However - you can use this as an exported function on an as-needed basis.
- Add priority flag functionality to NC checks. When a NC check is indicated to be "high priority" - the CDM/ROM Excel output will be highlighted in a light red - drawing attention to the check as a "priority" item.
- Add additional log comments for reading in datasets to declare what the printed out URL means and whether the dataset readin was successful


**Report Updates**
- Add code to include standardized lab values and standardized lab units in the HTML report while continuing to exclude them from the CDM/ROM report.
- Updated HTML report formatting
  -  Add bold to check information and results headers
  -  Add subtle delimiter between critical check results
  -  Add "Send check to CDM/ROM" indicator to check information for all checks
- Add % units to CC5 and CC6 output
- Add Number of Current Rows and Number of Old Rows to CC5 and CC6 results output


**Registry-Specific Updates**
- All Registries
  - Added a priority flag variable to ALL noncritical checks to be used in highlighting CDM/ROM report priority checks
  - Add standardized lab values and standardized lab units to all applicable lab check results listings to be included in HTML report. This was added in for all applicable registries.
  - NC21 Revamp - Removed unused columns and made overall table easier to read
    - Removed Init and Prev columns
    - Sort by countTotDiff
- PSO
  - Add code for NC21
- NMO
  - Add code for NC21
- IBD
  - Add IBD_drug_summary to output
  - Add code for NC21
  - Add code for NC33

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

