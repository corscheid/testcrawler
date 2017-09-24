require 'yaml'
require 'anemone'

# some settings
time = Time.new
config_file = YAML.load_file('config.yaml')
url = (ARGV.length > 0 && ARGV[0].start_with?('http')) ? ARGV[0] : config_file['url']

# setup the output file
log_file = File.open('testcrawler.log', 'a')
log_file.puts "#{time.inspect}\n\n"

# crawl the site and gather urls, codes, etc.
Anemone.crawl(url) do |anemone|
  anemone.on_every_page do |page|
    log_file.puts "[#{page.code}] #{page.url}"
    log_file.puts "`-- <#{page.depth} deep> referer: #{page.referer}"
  end
end
log_file.puts "\n"
log_file.close
