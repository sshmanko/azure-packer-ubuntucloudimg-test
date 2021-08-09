$global:progressPreference = 'silentlyContinue'
# Build images
cd D:\packer

# Get Start Time
$startDTM = (Get-Date)

Invoke-WebRequest -Uri https://cloudbase.it/downloads/qemu-img-win-x64-2_3_0.zip -OutFile qemu-img-win-x64-2_3_0.zip
Invoke-WebRequest -Uri https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img -OutFile focal-server-cloudimg-amd64.img
 
$ExtractShell = New-Object -ComObject Shell.Application 
$Files = $ExtractShell.Namespace("qemu-img-win-x64-2_3_0.zip").Items() 
$ExtractShell.NameSpace("D:\packer").CopyHere($Files) 
Start-Process "D:\packer"

& qemu-img.exe convert -p -f qcow2 -O vhdx focal-server-cloudimg-amd64.img focal-server-cloudimg-amd64.vhdx
Get-FileHash focal-server-cloudimg-amd64.vhdx | Select-Object -Property Hash | Out-File -FilePath D:\isochecksum

packer build .

$endDTM = (Get-Date)
Write-Host "[INFO]  - Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds" -ForegroundColor Yellow

Convert-VHD -Path "D:\packer\output\Virtual Hard Disks\packer-vm.vhdx" -DestinationPath "D:\packer\output\Virtual Hard Disks\packer-vm.vhd" -VHDType Fixed
(Get-VHD 'D:\packer\output\Virtual Hard Disks\packer-vm.vhd').FileSize | Out-File -FilePath D:\disksize
