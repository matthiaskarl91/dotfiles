let
  matthias = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKqItfBG5wxaVZoy1lLXgYLQHx2iyTV+IATTY+gWzgZ matthias.karl@cmdscale.com";
  router = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPt+N1JNPNhQjNEAfLbHM0rf81Q7FD75RNbeXLN9v+Y";
  users = [ matthias ];
  hosts = [ router ];
in
{
  "secrets/wifiPasswordFile.age".publicKeys = users ++ hosts;
  "secrets/wifiPskFile.age".publicKeys = users ++ hosts;
}
