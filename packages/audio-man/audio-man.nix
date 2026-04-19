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

let
  system = stdenv.hostPlatform.system;
  agsPkg = ags.packages.${system}.default;
  astal4 = ags.packages.${system}.astal4;
  astal3 = ags.packages.${system}.astal3;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "audio-man";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Daniel36191";
    repo = "audio-man";
    rev = "e41730ecf1480500517f3c3a657c6348c610594c";
    hash = "sha256-0zkfh4cPolNFE8sDoZt9s0YdwMQHqS5wmUVBW1YbDaU=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    agsPkg
  ];

  buildInputs = [
    libadwaita
    libsoup_3
    gjs
    astal4
    astal3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share
    cp -r * $out/share
    ags bundle app.ts $out/bin/audio-man -d "SRC='$out/share'"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/audio-man \
      --prefix GI_TYPELIB_PATH : "${
        lib.makeSearchPathOutput "lib" "girepository-1.0" [
          astal4
          astal3
        ]
      }"
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
