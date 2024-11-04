Import-Module AWS.Tools.S3

$region = "us-east-1"

$bucketname = Read-Host -Prompt 'Enter the S3 bucket name'

Write-Host "AWS Region: $region"
Write-Host "S3 Bucket: $bucketname"

function BucketExists {
    $bucket = Get-S3Bucket -BucketName $bucketname -ErrorAction SilentlyContinue
    return $null -ne $bucket
}

if (-not (BucketExists)){
    Write-Host "Bucket does not exist..."
    New-S3Bucket -BucketName $bucketname -Region $region
} else {
    Write-Host "Bucket already exists..."
}

# Create a new file

$fileName = 'myfile.txt'
$fileContent = 'Hello World!'
Set-Content -Path $fileName -Value $fileContent

Write-S3Object -BucketName $bucketname -File $fileName -Key $fileName