# readme

```
nix-shell -p wget --run "wget https://raw.githubusercontent.com/lvnilesh/nixos-config/refs/heads/master/flake.nix"

mkdir -p ~/nixos-config
mv flake.nix ~/nixos-config/flake.nix

sudo nixos-rebuild switch --flake ~/nixos-config/#my-overrides --impure
```
