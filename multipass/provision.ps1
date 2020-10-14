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