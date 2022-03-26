{ config, pkgs, ... }:
let
  rss = [
    "https://news.ycombinator.com/rss"
    "https://stackoverflow.blog/feed/"
    "https://codeburst.io/feed"
    "https://itsfoss.com/feed"
    "http://feeds.feedburner.com/d0od"
    "https://opensource.com/feed"
    "https://blogs.oracle.com/javamagazine/compendium/rss"
    "http://feeds.feedburner.com/JavaCodeGeeks"
    "http://feeds.feedburner.com/Torrentfreak"
    "http://rss.slashdot.org/Slashdot/slashdotMain"
    "https://www.ta3.com/rss/top/top-spravy.html"
    "https://rss.dw.com/atom/rss-de-top"
    "https://medium.com/feed/dailyjs"
  ];
in {
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "\"firefox '%u' > /dev/null 2>&1\"";
    maxItems = 50;

    urls = (map (x: { url = x; tags = [ "rss" ]; }) rss );

    extraConfig = ''
      include ${pkgs.newsboat}/share/doc/newsboat/contrib/colorschemes/solarized-dark

      # unbind keys
      unbind-key ENTER
      unbind-key j
      unbind-key k
      unbind-key J
      unbind-key K

      # bind keys - vim style
      bind-key j down
      bind-key k up
      bind-key l open
      bind-key h quit

      # highlights
      highlight article "^(Title):.*$" blue default
      highlight article "https?://[^ ]+" red default
      highlight article "\\[image\\ [0-9]+\\]" green default
    '';
  };
}
