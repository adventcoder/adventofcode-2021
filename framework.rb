require 'fileutils'
require 'net/http'

$session = '53616c7465645f5f64f477d1c45f938afca8c89ee4d129ff9e24c1b00dd8724922e9bf1325396c0ea2c9ef9979c651bd'

def opt?(name)
  ARGV.include?("--#{name}")
end

def optarg(name)
  i = ARGV.index("--#{name}")
  return nil if i.nil? || i >= ARGV.size - 1
  ARGV[i + 1]
end

def get_input(day)
  if file = optarg('input')
    if file == '-'
      $stdin.read
    else
      File.read(file)
    end
  else
    get_session_input(day)
  end
end

def get_session_input(day)
  cache("#{$session}/input-#{day}.txt") do
    http = Net::HTTP.new('adventofcode.com', 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new("/2021/day/#{day}/input")
    request['Cookie'] = "session=#{$session}"
    response = http.request(request)
    case response
    when Net::HTTPSuccess
      response.body
    else
      response.error!
    end
  end
end

def cache(name)
  path = File.join('cache', name)
  if File.exist?(path)
    File.read(path)
  else
    contents = yield
    begin
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, contents)
    rescue => error
      warn("unable to write to cache: #{error.message}")
    end
    contents
  end
end
