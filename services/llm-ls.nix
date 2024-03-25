  
{pkgs, lib, ...}:{
  systemd.services.llm-ls = {
    wantedBy = [ "multi-user.target" ];
    description = "LSP Server for local large language models";
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.llm-ls}";
    };
  };
  environment.systemPackages = [ pkgs.llm-ls ];
}
