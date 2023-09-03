{ config, pkgs, ... }:
let
  rss = [
    "https://primamateria.github.io/blog/atom.xml"
    "https://news.ycombinator.com/rss"
    "https://discourse.nixos.org/c/announcements/8.rss"
    "https://itsfoss.com/feed"
    "http://feeds.feedburner.com/d0od"
    "https://opensource.com/feed"
    "http://feeds.feedburner.com/Torrentfreak"
    "https://www.ta3.com/rss/top/top-spravy.html"
    "https://rss.dw.com/atom/rss-de-top"
    "https://medium.com/feed/dailyjs"
    "https://determinate.systems/rss.xml"
    "https://drakerossman.com/feed.xml"
    "https://emauton.org/feed/atom/"
    "https://fettblog.eu/feed.xml"
    "https://blog.kubukoz.com/atom.xml"
    "https://kyleshevlin.com/rss.xml"
    "https://www.nma-fallout.com/articles/index.rss"
    "https://jesseduffield.com/feed.xml"
    "http://randsinrepose.com/feed/"
    "https://blog.sekun.net/index.xml"
    "https://dataswamp.org/~solene/rss-html.xml"
    "https://blog.sulami.xyz/atom.xml"
    "https://countvajhula.com/feed/"
    "https://dotfyle.com/this-week-in-neovim/rss.xml"
    "https://www.getrevue.co/profile/thisweekinreact?format=rss"
    "https://xeiaso.net/blog.rss"
    "https://jovica.org/posts/index.xml"
  ];
in
{
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "\"firefox '%u' > /dev/null 2>&1\"";
    maxItems = 50;

    urls = (map (x: { url = x; tags = [ "rss" ]; }) rss);

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
