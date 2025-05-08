rec {

  overlaysToModule = overlays: {
    nixpkgs.overlays = overlays;
  };

  packageMapper = mapper: overlaysToModule [ mapper ];
}
