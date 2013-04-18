STDERR.puts "Running job!"
STDERR.puts "Data: #{data.inspect}"

mb = Win32API.new("user32", "MessageBox", ['i','p','p','i'], 'i')
mb.call(0, data['message'], data['title'], 0)

true
