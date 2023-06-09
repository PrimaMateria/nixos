{
  description = "Youtube Ambients";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };
  outputs = inputs@{ self, ... }:
    let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [ yt-dlp ffmpeg ];
        shellHook = ''
          alias download='yt-dlp https://www.youtube.com/playlist?list=PLjDqZb1FVlst1XPXongf5UD02yU9Md-ot -x'
          # alias extract='find ./ -exec ffmpeg -i {} -vn -acodec libmp3lame ../mp3/{}.mp3 \;'
          echo 'ytdl shell'
        '';

      };
    };
}
