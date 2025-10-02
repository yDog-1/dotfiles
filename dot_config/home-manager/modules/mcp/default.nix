{
  pkgs,
  inputs,
  ...
}: let
  config = inputs.mcp-servers-nix.lib.mkConfig pkgs {
    flavor = "codex";
    format = "toml-inline";
    fileName = ".mcp.toml";
    programs = {
      context7.enable = true;
      serena = {
        enable = true;
        context = "chatgpt";
        enableWebDashboard = false;
      };
    };
  };
in {
  home.packages = [
    (pkgs.writeShellScriptBin "codex" ''
      exec ${pkgs.bun}/bin/bunx @openai/codex@latest -c "$(cat ${config})" "$@"
    '')
  ];
}
