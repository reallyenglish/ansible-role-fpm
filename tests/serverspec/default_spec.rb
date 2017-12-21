require "spec_helper"
require "serverspec"

package = "fpm"
service = "fpm"
config  = "/etc/fpm/fpm.conf"
# user    = "fpm"
# group   = "fpm"
ports   = [9000]
# log_dir = "/var/log/fpm"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/php-fpm.conf"
  package = "php56"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("listen = 0.0.0.0:9000") }
  its(:content) { should match(/user = www/) }
end

# describe file(log_dir) do
#   it { should exist }
#   it { should be_mode 755 }
#   it { should be_owned_by user }
#   it { should be_grouped_into group }
# end

# case os[:family]
# when 'freebsd'
#   describe file('/etc/rc.conf.d/fpm') do
#     it { should be_file }
#   end
# end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
