# nix-frankenterm

Nix package, Flake, and Home Manager module for [FrankenTerm (`ft`)](https://github.com/Dicklesworthstone/frankenterm) — swarm-native terminal platform and orchestrator for AI agent fleets.

## Features

- **Swarm Orchestration**: Autonomous agent coordination, pane observation, mission transaction control, and workflow automation built on an evolved WezTerm foundation.
- **Full CLI Surface**: Exposes both `ft` and `frankenterm` commands.
- **Model Context Protocol (MCP)**: Built-in MCP server commands to integrate terminal fleet context into AI coding assistants (Claude Code, Antigravity, OpenCode, Codex).
- **Audit & Safety**: Decision logs, policy gates, approval tracking, and crash-recovery session persistence.
- **Multi-Platform Support**: `x86_64-linux`, `aarch64-linux`, `aarch64-darwin`.

---

## Usage

### Run directly with Flakes

```bash
nix run github:deepwatrcreatur/nix-frankenterm -- --help
# or run with the 'ft' binary alias:
nix run github:deepwatrcreatur/nix-frankenterm#ft -- --version
```

### Temporary Development Shell

```bash
nix shell github:deepwatrcreatur/nix-frankenterm
ft doctor
```

---

## Integration in NixOS / Home Manager

### 1. Add Flake Input

In your system or user `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-frankenterm = {
      url = "github:deepwatrcreatur/nix-frankenterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

### 2. Using the Home Manager Module

```nix
{ inputs, ... }:
{
  imports = [
    inputs.nix-frankenterm.homeManagerModules.default
  ];

  programs.frankenterm.enable = true;
}
```

### 3. Using via Overlay

```nix
{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nix-frankenterm.overlays.default
  ];

  environment.systemPackages = [
    pkgs.frankenterm # or pkgs.ft
  ];
}
```

---

## Comparison: FrankenTerm (`ft`) vs. Herdr

| Feature | Herdr (`herdr`) | FrankenTerm (`ft`) |
| :--- | :--- | :--- |
| **Foundation** | Custom terminal multiplexer written in Rust | Evolved WezTerm core with headless watcher daemon |
| **Agent Multiplexing** | Native multi-agent session launcher / grid view | Swarm-native agent fleet orchestrator with transaction control (`ft mission`, `ft steer`) |
| **Observation** | Pane viewing & switching | FTS query search (`ft search`), real-time event ingestion (`ft event`), timeline correlation |
| **AI Integration** | CLI session harness | Built-in MCP server (`ft mcp`), robot mode (`ft robot`), policy preflight & approval codes |
| **State Persistence** | Session workspace state | SQLite persistent backend (`ft db`), crash recovery, session snapshots |

---

## Upstream Project

- Repository: [Dicklesworthstone/frankenterm](https://github.com/Dicklesworthstone/frankenterm)
- Author: Jeffrey Emanuel
