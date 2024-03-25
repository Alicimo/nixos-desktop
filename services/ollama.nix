  
{pkgs, lib, ...}:
let
  my-ollama = (pkgs.unstable.ollama.override { acceleration = "rocm"; });
in {
  systemd.services.ollama = {
    wantedBy = [ "multi-user.target" ];
    description = "Server for local large language models";
    after = [ "network.target" ];
    environment = {
      HOME = "%S/ollama";
      OLLAMA_MODELS = "%S/ollama/models";
      OLLAMA_HOST = "127.0.0.1:11434";
    };
    serviceConfig = {
      ExecStart = "${lib.getExe my-ollama} serve";
      WorkingDirectory = "/var/lib/ollama";
      StateDirectory = [ "ollama" ];
      DynamicUser = true;
    };
  };
  environment.systemPackages = [ my-ollama ];
}
