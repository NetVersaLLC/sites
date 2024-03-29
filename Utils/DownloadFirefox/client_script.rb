require 'tmpdir'

ENV['ca_file'] = data['ca_file']
 def http_download(url, full_path, count)
    begin
      uri = URI.parse(url)
      filename = File.basename(uri.path)
      if ENV['HTTP_PROXY']
        protocol, userinfo, proxy_host, proxy_port  = URI::split(ENV['HTTP_PROXY'])
        proxy_user, proxy_pass = userinfo.split(/:/) if userinfo
        http = Net::HTTP.new(uri.host, uri.port, proxy_host, proxy_port, proxy_user, proxy_pass)
      else
        http = Net::HTTP.new(uri.host, uri.port)
      end
      if uri.scheme.downcase == 'https'
        http.use_ssl = true
	puts "Ca file: #{ENV['ca_file']}"
        if ENV['ca_file']
          cert_file = ENV['ca_file'].dup
          cert_file.gsub!(File::ALT_SEPARATOR, File::SEPARATOR) if File::ALT_SEPARATOR
        end
        if cert_file && File.exists?(cert_file)
          http.ca_file = cert_file
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          http.verify_depth = @max_ca_verify_depth
        else          
          raise <<-EOT
To download using HTTPS you must first set the ca_File
environment variable to the path of a valid CA certificate file.
A file of bundled public CA certs may be downloaded from:
 
   http://curl.haxx.se/ca/cacert.pem
 
          EOT
        end
      end
      http.request_get(uri.path) do |response|
        case response          
        when Net::HTTPNotFound
          puts "404 - Not Found"
          return false
        when Net::HTTPClientError
          puts "Error: Client Error: #{response.inspect}"
          return false
 
        when Net::HTTPRedirection
          raise "Too many redirections for the original URL, halting." if count <= 0
          url = response["location"]
          return http_download(url, full_path, count - 1)
 
        when Net::HTTPOK
          temp_file = Tempfile.new("download-#{filename}")
          temp_file.binmode
          size = 0
          progress = 0
          total = response.header["Content-Length"].to_i
          response.read_body do |chunk|
            temp_file << chunk
          end
          temp_file.close
          File.unlink full_path if File.exists?(full_path)
          FileUtils.mkdir_p File.dirname(full_path)
          FileUtils.mv temp_file.path, full_path, :force => true
        end
      end
 
    rescue Exception => e
      File.unlink full_path if File.exists?(full_path)
      puts "ERROR: #{e.message}"
      raise "Failed to download file"
    end
  end


tmpexe = "#{Dir.tmpdir}/FireFoxSetup.exe"
http_download("http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/23.0.1/win32/en-US/Firefox%20Setup%2023.0.1.exe", tmpexe, 3)

if File.exists? tmpexe
  system tmpexe
else
  puts "Could not download firefox!"
end

true
