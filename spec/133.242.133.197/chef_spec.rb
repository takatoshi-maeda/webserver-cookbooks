require 'spec_helper'

describe '/etc/chef' do
  it { should be_directory }
  it { should be_mode 775 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'sysadmin' }
end
