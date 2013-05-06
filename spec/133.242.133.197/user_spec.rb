require 'spec_helper'

describe 'tmaeda' do
  it { should be_user }
  it { should belong_to_group 'sysadmin' }
  it { should have_uid 2001 }
  it { should have_gid 2001 }
  it { should have_authorized_key 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3Gc4fy+vatZj3YhzQ0Yqi0Xy6Ggv0Je2wrChj/UFkYB7ehQjcHPDx+t7y1Xol+eBiIcK3cf1W7MawDSd8832xOCvchY6bcSG0oQZPiMHuLXTXIaLj/MFJ7hx+fZcOvtf7J8Tt9nBZU8OZNfdDYCQD1GKVIwS6zehR2wBOBVHZQ2yTPxdZKsm3a3EI4eUoIWxgpVGm3x9/ngGEZDJ1qdZ0863eV6DoDy5lhYJQfGBIuNJRTL/Y/Bo5nZ+t+laiRonYOjZLYYXoeXU1oygRf38l+OUtPMf9x1h//3gxgy5LU/68A2nB1jxGIHGSEE8YTqkh6g48HwzbgXZYRTzdznOT'}
end
