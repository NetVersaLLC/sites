eval File.open('../shared.rb').read

def confirm_created_business

	puts 'Continue to configm Google business page.'

	site = 'https://plus.google.com/u/0/pages/manage'
	
	# TODO
end

def main( business )
	confirm_created_business
end

if main( data ) == true
  true
else
  false
end
