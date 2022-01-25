{ config, pkgs, ... }:

let
  user = "primamateria";
  group = "users";
  secrets = import ../.secrets/rclone.nix;
  mountPath = "/home/${user}/gdrive";
  mountSource = "gdrive:";
  cacheDir = "/home/${user}/.cache/rclone-gdrive";
  configPath = "/var/run/rclone.conf";
  rcloneConfigData = ''
    [gdrive]
    type = drive
    client_id = ${secrets.clientId}
    client_secret = ${secrets.clientSecret}
    scope = drive
    token = {"access_token":"${secrets.accessToken}","token_type":"Bearer","refresh_token":"${secrets.refreshToken}","expiry":"${secrets.expiry}"}
    team_drive =
  '';
  rcloneConf = pkgs.writeText "rclone.conf" rcloneConfigData;
in
{
  security.wrappers = {
    fusermount = {
      source = "${pkgs.fuse}/bin/fusermount";
      setuid = true;
      setgid = false;
    };
  };

  environment.etc."fuse.conf".text = ''
    user_allow_other
  '';

  systemd.services.rclone-init = {
    script = ''
      /run/current-system/sw/bin/cp ${rcloneConf} ${configPath}
      /run/current-system/sw/bin/chmod 600 ${configPath}
      /run/current-system/sw/bin/mkdir -p ${mountPath} ${cacheDir}
      /run/current-system/sw/bin/chown ${user}:${group} ${mountPath} ${cacheDir}
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.rclone-mount = {
    description = "rclone google drive mount";
    after = [ "rclone-init.service" ];
    serviceConfig = {
      Type = "notify";
      ExecStart = ''
        /run/current-system/sw/bin/rclone \
         mount \
          --allow-other \
          --vfs-cache-mode full \
          --cache-dir ${cacheDir} \
          --no-modtime \
          --config ${configPath} \
          ${mountSource} \
          ${mountPath}
      '';
      ExecStop = "${config.security.wrapperDir}/fusermount -u ${mountPath}";
      Restart = "always";
      RestartSec = 10;
    };
    path = [
      pkgs.rclone
      pkgs.fuse
      config.security.wrapperDir
    ];
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.rclone-init.enable = true;
  systemd.services.rclone-mount.enable = true;
}
