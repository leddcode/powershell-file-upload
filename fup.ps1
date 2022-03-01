param([string]$path)
$filename = ($path).Trim(".\")

if([System.IO.File]::Exists($path)){

	$Headers = @{"Content-Type" = "multipart/form-data"}
	$Uri = "https://trophyio.herokuapp.com/hackandupload/"

	$fileBytes = [System.IO.File]::ReadAllBytes($path);
	$fileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes);
	$boundary = [System.Guid]::NewGuid().ToString(); 
	$LF = "`r`n";

	$bodyLines = ( 
		"--$boundary",
		"Content-Disposition: form-data; name=`"insert`"$LF",
		"true$LF",
		"--$boundary",
		"Content-Disposition: form-data; name=`"debug`"$LF",
		"true$LF",    
		"--$boundary",
		"Content-Disposition: form-data; name=`"uploadedFile`"; filename=`"$filename`"",
		"Content-Type: application/octet-stream$LF",
		$fileEnc,
		"--$boundary--$LF" 
	) -join $LF

	$res = Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Post -ContentType "multipart/form-data; boundary=`"$boundary`"" -Body $bodyLines
	write-host("")
	write-host("[+] The file was successfully uploaded!")
	write-host("")
} else {
	write-host("")
	write-host("[-] Check the file path and try again!")
	write-host("")
}