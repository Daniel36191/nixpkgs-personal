{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  agsPkg,
  astal4,
  astal3,
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

  meta = {
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.linux;
  };
})
