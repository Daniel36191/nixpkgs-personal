{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  wrapGAppsHook3,
  gobject-introspection,
  ags,
  libadwaita,
  libsoup_3,
  gjs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "audio-man";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Daniel36191";
    repo = "audio-man";
    rev = "main";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    ags.packages.${stdenv.hostPlatform.system}.default
  ];

  buildInputs = [
    libadwaita
    libsoup_3
    gjs
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    cp -r * $out/share
    ags bundle app.ts $out/bin/audio-man -d "SRC='$out/share'"

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Audio manager widget for AGS";
    homepage = "https://github.com/TS-design-lab/audio-man";
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.linux;
  };
})
