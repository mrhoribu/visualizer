#!/usr/bin/env ruby
# frozen_string_literal: true

=begin
  Manifest Generator for Visualizer Assets
  
  This script scans a directory of PNG images and generates a manifest.yaml
  file with SHA256 checksums for each image.
  
  Usage:
    ruby generate_manifest.rb [image_directory] [output_file]
    
  Example:
    ruby generate_manifest.rb ./images manifest.yaml
=end

require 'digest'
require 'yaml'

def calculate_checksum(file_path)
  Digest::SHA256.file(file_path).hexdigest
end

def get_file_size(file_path)
  File.size(file_path)
end

def generate_manifest(image_dir, output_file)
  unless Dir.exist?(image_dir)
    puts "Error: Directory '#{image_dir}' does not exist"
    exit 1
  end

  png_files = Dir.glob(File.join(image_dir, '*.png')).sort
  
  if png_files.empty?
    puts "Error: No PNG files found in '#{image_dir}'"
    exit 1
  end

  puts "Found #{png_files.size} PNG files"
  puts "Generating checksums..."
  
  manifest = {}
  
  png_files.each_with_index do |file_path, index|
    filename = File.basename(file_path)
    print "  [#{index + 1}/#{png_files.size}] Processing #{filename}..."
    
    checksum = calculate_checksum(file_path)
    size = get_file_size(file_path)
    
    manifest[filename] = {
      'checksum' => checksum,
      'size' => size,
      'description' => generate_description(filename)
    }
    
    puts " ✓"
  end
  
  # Write manifest
  File.write(output_file, YAML.dump(manifest))
  puts "\nManifest written to: #{output_file}"
  puts "Total files: #{manifest.size}"
  
  # Display summary
  total_size = manifest.values.sum { |data| data['size'] }
  puts "Total size: #{format_bytes(total_size)}"
end

def generate_description(filename)
  case filename
  when /^u(\d+)\.png$/
    "Room UID #{Regexp.last_match(1)} image"
  when 'null.png'
    "Fallback image when room image not found"
  else
    "Location image: #{filename.gsub('.png', '')}"
  end
end

def format_bytes(bytes)
  if bytes < 1024
    "#{bytes} B"
  elsif bytes < 1024 * 1024
    "#{(bytes / 1024.0).round(2)} KB"
  else
    "#{(bytes / (1024.0 * 1024.0)).round(2)} MB"
  end
end

# Parse command line arguments
image_dir = ARGV[0] || './images'
output_file = ARGV[1] || 'manifest.yaml'

puts "Visualizer Manifest Generator"
puts "=" * 50
puts "Image directory: #{image_dir}"
puts "Output file: #{output_file}"
puts "=" * 50
puts ""

generate_manifest(image_dir, output_file)
puts "\nDone! Upload both manifest.yaml and the images directory to GitHub."
