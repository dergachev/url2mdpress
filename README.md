url2mdpress
===========

Wrapper on egonSchiele/mdpress that pulls markdown from URL.

I wrote it to download markdown from [Gingko](http://www.gingkoapp.com/) and
convert it to an [impress.js](https://github.com/bartaz/impress.js) slideshow, via the following command:

```bash
~/url2mdpress/url2mdpress.rb 
  --remove-horizontal-rules --slide-per-header \
  --move-mdpress-output \
  --cookie connect.sid=s%3ALE7Zi80AZijMX5hRuipZBein.LKJ1qADR2UqcRpxEl6JXRCgU8UqSGEYnlkFl4aP%2Fj0U \
  --url https://beta.gingkoapp.com/api/exports/2b8eba0efe143b2452000001.txt \
  -- -s evolvingweb
```
* Input:: https://beta.gingkoapp.com/2b8eba0efe143b2452000001
* Markdown:: https://raw.github.com/dergachev/vagrant-chef-guide/gh-pages/vagrant-chef-tutorial/presentation.md
* Output: http://dergachev.github.com/vagrant-chef-guide/vagrant-chef-tutorial/

## Usage

```bash
~/url2mdpress/url2mdpress.rb -h

Usage:
	url2mdpress [options] [-- extra-mdpress-args]

where [options] are:
                  --url, -u <s>:   Markdown URL
      --move-mdpress-output, -m:   Whether to move mdpress output files (index.html, css/, js/) to the current folder
        --save-markdown, -s <s>:   Save downloaded markdown to FILENAME in the current folder. (Default: presentation.md)
               --cookie, -c <s>:   Authentication cookie to use
         --mdpress-args, -d <s>:   Arguments for mdpress (eg '-s mytheme'), merged with [-- extra-mdpress-args]. (Default: -v)
               --config, -o <s>:   YAML file to read arguments from; file values override arguments. (Default: url2mdpress.yml)
  --remove-horizontal-rules, -r:   Remove all existing horizontal rules (---) in the markdown.
         --slide-per-header, -l:   Prepend horizontal rules (---) for each header (## Slide Title).
                     --help, -h:   Show this message
```

## Resources:

### Getting the session cookie

url2mdpress supports a --cookie argument, which lets it download markdown from
password protected websites.  You can extract the cookie via Chrome's Developer
Tools, as follows: [Screenshot](http://dl-web.dropbox.com/u/29440342/screenshots/XAIGKG-2013.2.27-14.47.png)

### mdpress

To install the required mdpress gem:

```bash
gem install mdpress
```

To get the "HEAD" version of the mdpress gem, do this:

```
git clone git://github.com/egonSchiele/mdpress.git
cd mdpress
gem build mdpress.gemspec
gem install mdpress-0.0.12.gem
```

### About mdpress and impress.js

* https://github.com/cubewebsites/Impress.js-Tutorial
* http://www.cubewebsites.com/blog/guides/how-to-use-impress-js/
* http://www.impressivewebs.com/html-slidedeck-toolkits/
* http://chronicle.com/blogs/profhacker/markdown-and-mdpress-for-presentations/46343

### Alternative tools

* fork of Reveal JS that works with markdown (fork!)
 - https://github.com/webpro/reveal.js/commit/5dd63e4919b58bde83591590bacf37a1f091fa2a
* http://wcm1.web.rice.edu/slides/onlinepub.html#/3 (reveal.js demo)
* https://github.com/adamzap/landslide
* https://github.com/railslove/showoff-presentations
* http://johnmacfarlane.net/pandoc/demo/example9/producing-slide-shows-with-pandoc.html
* https://github.com/jgm/pandoc/wiki/Using-pandoc-to-produce-reveal.js-slides
* http://johnmacfarlane.net/pandoc/README.html
* http://brianmcmurray.com/blog/2012/02/07/hekyll-for-awesome-easy-presentations/
