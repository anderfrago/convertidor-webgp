<#
Image converter (jpg/png) to webp.

Converts all images located inside the public folder, keeping the structure.
#>


$path = ".\images"
$pathCwepg = "$(Get-Location)\libwebp-1.3.2-windows-x64\bin"



function fileConvertet($path){
    
    #Using PowerShell to Determine if Path Is to File or Folder
    if( $(Get-Item $path) -is [System.IO.DirectoryInfo]) {
        Set-Location $path
            foreach( $content in $path){
            $item = Get-ChildItem $content.FullName

            foreach($file in $item) {

                if( $(Get-Item $file) -is [System.IO.DirectoryInfo]) {
                    #is not a file is a directory
                    fileConvertet($file)
                }
                $file
                if ( $file -cmatch '[aA0-zZ9]+\.jpg|[aA0-zZ9]+\.png') {
                    $fileName =$file.Name.Substring(0, $file.Name.lastIndexOf('.'))
                    $target = (get-location ).Path
                    cwebp -q 80 "$file" -o "$fileName.webp"
                    ri $file
                }
            }
        }
        Set-Location ..
    } else {
        Write-Host $content is file
         $fileName =$content.Name.Substring(0, $content.Name.lastIndexOf('.'))
        $target = (get-location ).Path
        cwebp -q 80 "$content" -o "$fileName.webp"
        ri $content
    }

}


if (Test-Path -Path $path) {  
  ## Go through folder structure
  Set-Location $path
  foreach($item in "."){     
    $subfolder = Get-ChildItem $item.FullName
    foreach($content in $subfolder) {
          if ( $content -cmatch '\.[^.]+jpg$' -or $content  -cmatch '\.[^.]+png$' ) {
                $fileName = $content.ToString().Substring('.')[0];
                $target = (get-location ).Path
                cwebp -q 80 "$content" -o "$fileName.webp"
                ri $content
            }
                fileConvertet('.')               

    } 
  }
  Set-Location ..
  ##Rename-Item -Path $path "old_images" -Force
  ##New-Item -ItemType Directory -Path $path -Force > $null
} else {
    Write-Host Las imágenes deben de situarse dentro de una carpeta images
}



