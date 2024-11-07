# Require the AWS SDK for Ruby to work with AWS services and 'pry' for debugging
require 'aws-sdk-s3'
require 'pry'
require 'securerandom' # Required to generate random UUIDs for file content

# Get the bucket name from environment variables
bucket_name = ENV['BUCKET_NAME']
# Set the AWS region where the bucket will be created
region = 'us-east-2'

# Initialize an S3 client to interact with AWS S3
client = Aws::S3::Client.new

# Create the bucket without a location constraint if the region is 'us-east-1'
if region == 'us-east-2'
    resp = client.create_bucket({
      bucket: bucket_name
    })
  else
    resp = client.create_bucket({
      bucket: bucket_name,
      create_bucket_configuration: {
        location_constraint: region
      }
    })
  end

# Generate a random number of files to create and upload (between 1 and 6)
number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"

# Loop through the specified number of times to create each file
number_of_files.times.each do |i|
  puts "i: #{i}"
  # Define a filename for each file, e.g., file_0.txt, file_1.txt, etc.
  filename = "file_#{i}.txt"
  output_path = "/tmp/#{filename}" # Local path for temporary file storage

  # Create a new file with the specified name and write a unique identifier (UUID) to it
  File.open(output_path, "w") do |f|
    f.write(SecureRandom.uuid) # Writes a unique UUID string to the file
  end

  # Reopen the file in read-binary mode to prepare for uploading to S3
  File.open(output_path, 'rb') do |f|
    # Upload the file to the S3 bucket with the specified filename as the S3 key
    client.put_object(
      bucket: bucket_name,
      key: filename,
      body: f
    )
  end
end