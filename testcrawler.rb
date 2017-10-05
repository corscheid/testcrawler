require 'yaml'
require 'anemone'
require 'gmail'

# print help page and exit
if ARGV.include?('-h') || ARGV.include?('--help')
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
config_file = YAML.load_file(File.dirname(__FILE__) + '/config.yaml')
url = !ARGV.empty? && ARGV[0].start_with?('http') ? ARGV[0] : config_file['url']
to_addr = config_file['to_addr']
cc_addr = config_file['cc_addr']
to_name = config_file['to_name']
username = config_file['username']
password = config_file['password']
m_subject = config_file['m_subject']
greeting = config_file['greeting']
intro = config_file['intro']
message = %(#{greeting} #{to_name},

#{intro}
)
results_body = ''
quiet = ARGV.include?('-q') || ARGV.include?('--quiet')

# setup the output file
log_file = File.open(File.dirname(__FILE__) + '/testcrawler.log', 'a')
log_file.puts "#{time.inspect}\n\n"

# crawl the site and gather urls, codes, etc.
Anemone.crawl(url) do |anemone|
  anemone.on_every_page do |page|
    # log to stdout
    puts "[#{page.code}] #{page.url}" unless quiet
    puts "`-- <#{page.depth} deep> referer: #{page.referer}" unless quiet
    # log to file
    log_file.puts "[#{page.code}] #{page.url}"
    log_file.puts "`-- <#{page.depth} deep> referer: #{page.referer}"
    # log to email
    results_body += %(
    [#{page.code}] #{page.url}
    `-- <#{page.depth} deep> referer: #{page.referer}
    )
  end
end
log_file.puts "\n"
log_file.close
# finish building the email
message += results_body

# connect to Gmail and send the message
gmail = Gmail.connect(username, password)
email = gmail.compose do
  to to_addr
  cc cc_addr
  subject m_subject
  body message
end
gmail.deliver(email)
gmail.logout
