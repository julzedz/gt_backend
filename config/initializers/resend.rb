puts "Loading Resend configuration..."
puts "API Key present? #{!ENV['RESEND_API_KEY'].nil?}"
Resend.api_key = ENV['RESEND_API_KEY']
puts "Resend configuration loaded!"