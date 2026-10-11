{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, installShellFiles
}:

let
  version = "0.15.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/Dicklesworthstone/frankenterm/releases/download/v${version}/ft-linux-amd64.tar.xz";
      hash = "sha256-8GNGAnWDZ5n6iHonZWFshxCbQQuevvH+u/7hBjdt4S8=";
    };
    aarch64-linux = {
      url = "https://github.com/Dicklesworthstone/frankenterm/releases/download/v${version}/ft-linux-arm64.tar.xz";
      hash = "sha256-iFWnaV8+vXkRkcPpKKm++GecfUBy2GVv43nJOxQwj1I=";
    };
    aarch64-darwin = {
      url = "https://github.com/Dicklesworthstone/frankenterm/releases/download/v${version}/ft-darwin-arm64.tar.xz";
      hash = "sha256-Sa6HGNF77fYFc8UZTxUF/SFMhY6tOVG5brChCK6WnCE=";
    };
  };

  platform = stdenv.hostPlatform.system;
  source = sources.${platform} or (throw "Unsupported platform: ${platform}");

in stdenv.mkDerivation {
  pname = "frankenterm";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    installShellFiles
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ft $out/bin/ft
    ln -s ft $out/bin/frankenterm

    if [ -f README.md ]; then
      install -Dm644 README.md $out/share/doc/frankenterm/README.md
    fi
    if [ -f CHANGELOG.md ]; then
      install -Dm644 CHANGELOG.md $out/share/doc/frankenterm/CHANGELOG.md
    fi
    if [ -f LICENSE ]; then
      install -Dm644 LICENSE $out/share/licenses/frankenterm/LICENSE
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Swarm-native terminal platform and agent orchestrator for AI agent fleets";
    longDescription = ''
      FrankenTerm (ft) is an autonomous agent orchestration and terminal platform
      built on an evolved WezTerm foundation. It provides swarm-native multiplexing,
      pane observation, workflow automation, audit trails, and Model Context Protocol
      (MCP) integration for AI agent fleets.
    '';
    homepage = "https://github.com/Dicklesworthstone/frankenterm";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    mainProgram = "ft";
  };
}
