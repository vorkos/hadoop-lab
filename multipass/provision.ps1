Param(
  [int] $count = 4,
  [int] $cpu = 2,
  [string] $memory = "4G",
  [string] $disk = "20G",
  [string] $cloud_init = ".\ci.yaml"
)
For ($i=0; $i -lt $count; $i++) {
    multipass launch -m $memory -d $disk -c $cpu --cloud-init $cloud_init
}

$list_machines = multipass list --format json | ConvertFrom-Json | select -expand list | select name, ipv4 

"[hadoop]"|Out-File -append hosts
For($i=0; $i -lt $list_machines.Length; $i++) {
    $name = $list_machines[$i].name
    $ipv4 = $list_machines[$i].ipv4
    if($i -eq 0 ) {
      $role = "master"
      $master = $list_machines[$i]
      $master.ipv4 = $list_machines[$i].ipv4[0]
    } else {
      $role = "worker"
    }
    $list_machines[$i] | Add-Member -NotePropertyName role -NotePropertyValue $role
    "{0,-20} ansible_user=ansible  ansible_host={1,-20} role={2,-20}" -f $name,$ipv4[0],$role | Out-File -append hosts 
}

"[hadoop:vars]"|Out-File -append hosts
"master_hostname={0,-20} `nmaster_ip={1,-20}" -f $master.name,$master.ipv4 | Out-File -append hosts
"[workers]"|Out-File -append hosts
foreach ($worker in $list_machines) {
    if ($worker.role -eq "worker") {
        "{0,-20} ansible_user=ansible  ansible_host={1,-20}" -f $worker.name,$worker.ipv4[0] | Out-File -append hosts 
    }
}
"[masters]"|Out-File -append hosts
foreach ($master in $list_machines) {
    if ($master.role -eq "master") {
        "{0,-20} ansible_user=ansible  ansible_host={1,-20}" -f $worker.name,$master.ipv4[0] | Out-File -append hosts 
    }
}