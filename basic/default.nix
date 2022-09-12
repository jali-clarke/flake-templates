{ pkgs }:
pkgs.writeShellScriptBin "hello-world" ''
  echo "hello world!"
''
