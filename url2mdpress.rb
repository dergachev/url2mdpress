#!/usr/bin/env ruby
require 'rubygems'
require 'trollop'
require 'yaml'
require 'uri'
require 'open-uri'
require 'tempfile'

# require 'mdpress' # just for dependency

# require 'launchy'

OPTS = Trollop::options do
  banner <<-EOS
Usage:
	url2mdpress [options] [-- extra-mdpress-args]

where [options] are:
EOS
  opt :url,  "Markdown URL", :type => :string
  # TODO: implement these:
  # opt :output,  "HTML filename to output", :type => :string, 
  #   :default => "index.html"
  # opt :slide_header_level, ...
  
  opt :move_mdpress_output,  "Whether to move mdpress output files (index.html, css/, js/) to the current folder"
  opt :save_markdown,  "Save downloaded markdown to FILENAME in the current folder.", :type => :string,
    :default => 'presentation.md'
  opt :cookie, "Authentication cookie to use", :type => :string
  opt :mdpress_args,  "Arguments for mdpress (eg '-s mytheme'), merged with [-- extra-mdpress-args].", 
    :type => :string,
    :default => '-v'
  opt :config,  "YAML file to read arguments from; file values override arguments.", :type => :string,
    :default => 'url2mdpress.yml'
  opt :remove_horizontal_rules, "Remove all existing horizontal rules (---) in the markdown."
  opt :slide_per_header, "Prepend horizontal rules (---) for each header (## Slide Title)."

  stop_on "--" #everything afterwards -- goes to mdpress
end

if OPTS[:config] && File.exists?(OPTS[:config])
  CONF = YAML.load_file(OPTS[:config])
  OPTS.merge!(CONF)
end

if ARGV.shift == '--'
  OPTS[:mdpress_args] ||= ''
  OPTS[:mdpress_args] += " " + ARGV.join(" ")
end

Trollop.die :url, "must be a valid URL" unless OPTS[:url] =~ URI::regexp
# puts ARGV.first ;  exit
# Trollop::die("no file specified") if ARGV.empty? # show help screen
# puts OPTS.inspect ;  exit

markdown_content = ''

# def redefine_slides(txt, removeHR, slidePerHeader)
#   return txt
# end

open(OPTS[:url], "Cookie" => OPTS[:cookie]) do |src_f|
  if OPTS[:slide_per_header]
    markdown_content_filtered = []
    src_f.readlines.each_with_index do |s,i|
      markdown_content_filtered << "---\n" if i > 0 and s.match "^#"
      if OPTS[:remove_horizontal_rules]
        markdown_content_filtered << s.gsub(/^-+$/, "")
      else
        markdown_content_filtered << s
      end
    end
    markdown_content = markdown_content_filtered.join('')
  else
    markdown_content = src_f.read
  end
end

markdownfile = File.open(OPTS[:save_markdown], 'w') do |dst_f|
  dst_f.write(markdown_content)
end

system("mdpress #{OPTS[:save_markdown]} #{OPTS[:mdpress_args]}") 
$?.success?() or raise("mdpress call failed")

if OPTS[:move_mdpress_output]
  # presentation.md ==> presentation
  DIRNAME = File.basename(OPTS[:save_markdown], File.extname(OPTS[:save_markdown]))

  #FIXME: is this safe?
  FileUtils.cp_r(Dir.glob("#{DIRNAME}/*"), '.', :verbose => true)
  FileUtils.rm_rf(DIRNAME, :verbose => true)
end
