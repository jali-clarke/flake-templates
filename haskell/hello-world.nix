{ mkDerivation, base, hpack, hspec, lib, QuickCheck }:
mkDerivation {
  pname = "hello-world";
  version = "0.0.0.1";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base hspec QuickCheck ];
  prePatch = "hpack";
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
