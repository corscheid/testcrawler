# testcrawler
A simple web crawler that tests every url in a website for OK response
## configuration
`config.yaml`
```
url: 'https://example.com'
```
This is the default url to test on. Change this to be the document root of the site you want to test. Note that the url *must* start with http:// or https://
## usage
Print the help page:
```
$ ruby testcrawler.rb -h
$ ruby testcrawler.rb --help
```
Run with default url specified in configuration file:
```
$ ruby testcrawler.rb
```
Quick run with url specified in command line:
```
$ ruby testcrawler.rb https://example.com/
```
Run with default url and no output printed to stdout ("quiet mode"):
```
$ ruby testcrawler.rb -q
$ ruby testcrawler.rb --quiet
```
Quick run with specified url and quiet mode:
```
$ ruby testcrawler.rb https://example.com -q
$ ruby testcrawler.rb https://example.com --quiet
```
## log file
testcrawler logs all results to `testcrawler.log`, a plain text file. Entries are divided by newlines and timestamps.
