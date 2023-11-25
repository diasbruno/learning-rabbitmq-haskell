{ nixpkgs ? import (fetchTarball("channel:nixos-23.05")) {}, compiler ? "default", doBenchmark ? false }:
let
  inherit (nixpkgs) pkgs;
  sysDeps = with pkgs; [pkg-config zlib rabbitmq-c];
  hsDeps = with pkgs; [haskell.compiler.ghc928
                       cabal-install
                       haskell-language-server];
  
  hspkgs = pkgs.haskellPackages;
  hsExtraDeps = with hspkgs; [hoogle fourmolu];
in pkgs.mkShell {
  buildInputs = sysDeps ++ hsDeps ++ hsExtraDeps;
}
