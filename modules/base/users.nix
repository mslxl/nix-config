{myvars, ...}: {
  users.users.${myvars.username} = {
    description = myvars.userfullname;
    # Public Keys that can be used to login to all my PCs, Macbooks, and servers.
    #
    # Since its authority is so large, we must strengthen its security:
    # 1. The corresponding private key must be:
    #    1. Generated locally on every trusted client via:
    #      ```bash
    #      # KDF: bcrypt with 256 rounds, takes 2s on Apple M2):
    #      # Passphrase: digits + letters + symbols, 12+ chars
    #      ssh-keygen -t ed25519 -a 256 -C "ryan@xxx" -f ~/.ssh/xxx`
    #      ```
    #    2. Never leave the device and never sent over the network.
    # 2. Or just use hardware security keys like Yubikey/CanoKey.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAWzzDW+0ytfjSytMcESuf1CFiuRCnOBlNpw65wtsyk/o1DajVIWdwI4sGLOzk+oNncqJPiQQ7v5a43mjJJP9XFCa9ohiRgTIoHtiPllA+4Kqm6dson+Q0skvq9DV62Sv9gKaGAhmKyxTvxqIq71BGwzKiMO8jFuuD2+J+FqA4Bvkb/ygwWersdc5V7fZdid20iop7Zk+GV+G1+qRvqHlTAQDu8kcTlbqJri9Zd8/Xf1RjxMwfsyBKZH9uUjKGCJD7oGRlYggd+tZ1TfJ/FYcEi23jaYHgtmeWkmVs1ro69vtlXVm5+WGQ77RJrZeSVxMKQhYuQkpBsCeK+1hHlKix7VPG6iKyR2X1zbrqlonkN2TH9fr+8vCdDHdNS8n8yMi5qk9gKphB89ashPAa7LJdkXB2g6doYYB1Z8KTiD1/jsLglWIZwywRV+kSeUQT1L9zrskTysmcxXRhnHpygpQMuC4wxVhTdzroSkhep0V2Ap64mxd8eIZ4GQn3jaVTJ7M= i@mslxl.com"
    ];
  };
}
