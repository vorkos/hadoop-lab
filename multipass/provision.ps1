Param(
  [int] $count = 2,
  [int] $cpu = 2,
  [string] $memory = "4G",
  [string] $disk = "20G",
  [string] $cloud_init = ".\ci.yaml"
)
For ($i=0; $i -lt $count; $i++) {
    multipass launch -m $memory -d $disk -c $cpu --cloud-init $cloud_init
}

$list_machines = multipass list --format json | ConvertFrom-Json | select -expand list | select name, ipv4 

"[all]"|Out-File -append hosts
ForEach($machine in $list_machines){
    $name = $machine.name
    $ipv4 = $machine.ipv4
    "{0,-20} ansible_user=ansible  ansible_host={1,-20}" -f $name,$ipv4[0] | Out-File -append hosts 
}