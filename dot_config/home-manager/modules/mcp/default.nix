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
      memory.enable = true;
    };
    settings.servers = {
      sdd-mcp = {
        command = "${pkgs.bun}/bin/bunx";
        args = [
          "sdd-mcp@latest"

        ];
      };
    };
  };
in {
  home.packages = [
    (pkgs.writeShellScriptBin "codex" ''
      exec ${pkgs.bun}/bin/bunx @openai/codex@latest --search -c "$(cat ${config})" "$@"
    '')
  ];
}
