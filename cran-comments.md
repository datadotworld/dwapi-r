## Re: feedback on previous submission

### DESCRIPTION
- Add a URL for data.world: Added https://apidocs.data.world
- Use single quotes around software names (e.g. data.world): Done.

### Documentation
- Add more examples in Rd-files: Checked all exported functions and 
  verified that all include at least one example.
- Ensure that examples don't write by default to user's home filespace: 
  Modified examples to use `tempdir()` and `tempfile()`.

**Request for additional details**
In case the above measures are insufficient to meet your criteria, please provide more specific 
feedback indicating specific files and/or functions, for example.

## Test environments

* local OS X install, R 3.4.0
* win-builder (all versions)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Downstream dependencies

No ERRORs or WARNINGs found :)
