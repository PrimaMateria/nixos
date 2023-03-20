{ writeShellApplication }:

writeShellApplication {
  name = "i3block-datetime";

  runtimeInputs = [ ];

  text = ''
    DATETIME=$(date +'%H:%M %A %d.%m.%Y')
    echo "$DATETIME"
    echo "$DATETIME"
    echo "#FABD2F"
    exit 0
  '';
}
