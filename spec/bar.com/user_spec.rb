require 'spec_helper'

describe 'foo' do
  it { should be_user }
  it { should belong_to_group 'sysadmin' }
  it { should have_uid 2001 }
  it { should have_gid 2001 }
  it { should have_authorized_key ''}
end
