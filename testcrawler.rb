require 'yaml'
require 'anemone'

# print help page and exit
if ARGV.include?("-h") || ARGV.include?("--help")
  puts %(testcrawler [https://github.com/corscheid/testcrawler]
  usage: $ ruby testcrawler.rb [URL] [option]

  URL: must start with http:// or https://

  options
    -q (--quiet): do not print to stdout
    -h (--help):  print this help page and quit
  )
  exit 0
end

# some settings
time = Time.new
config_file = YAML.load_file('config.yaml')
url = (ARGV.length > 0 && ARGV[0].start_with?('http')) ? ARGV[0] : config_file['url']
quiet = ARGV.include?("-q") || ARGV.include?("--quiet")

# setup the output file
log_file = File.open('testcrawler.log', 'a')
log_file.puts "#{time.inspect}\n\n"

# crawl the site and gather urls, codes, etc.
Anemone.crawl(url) do |anemone|
  anemone.on_every_page do |page|
    puts "[#{page.code}] #{page.url}" unless quiet
    puts "`-- <#{page.depth} deep> referer: #{page.referer}" unless quiet
    log_file.puts "[#{page.code}] #{page.url}"
    log_file.puts "`-- <#{page.depth} deep> referer: #{page.referer}"
  end
end
log_file.puts "\n"
log_file.close
