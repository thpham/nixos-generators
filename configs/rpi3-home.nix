{ ... }:
{
  services.openssh.enable = true;
  
  # put your own configuration here, for example ssh keys:
  users.extraUsers.root.openssh.authorizedKeys.keys = [
     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkb3IO5IHWuhmT4NhQqHvChQNGbNL9bcPekD7X67MQPv+s839JbB2XrI8fXvlkDDxDwa+aofFuO3b54WqkYPXb8ShJ9qIcSDfETwsPPS/jLjOEj7f6OGkvPg9k5VYsXyb+8aKhRgeid4y0NLpuVwz6q8W3wocIWg5HS3zKpSGpG2W5+zSvVlsWBfxQfNSt+9REpyYmgAN4qJpMvfQNH2zBb3QkK/cDXEXG2hCK7v/AH09fR0D5BlwllVHxfUDoiQV18njGDlW2PgqY/xukI/LO/JOp84GJM4WpqWxsrkYl3ovY22BEJ+kuSNRIbR0za2/6y27bcE2MZP0ob691B+cT thomas.pham@ithings.ch"
  ];
}
