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
    rev = "7aff087afd4c213d423b9d4bdf96807f53e2e717";
    hash = "sha256-4nJ+SUHY4PiQsMG+vHulbnKrZqkwPCe9VDBa7zbGUVM=";
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
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/128x128/apps
    cp -r * $out/share
    install -m644 $src/audio-man.desktop $out/share/applications/audio-man.desktop
    install -m644 $src/audio-man.png $out/share/icons/hicolor/128x128/apps/audio-man.png
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
