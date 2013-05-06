name 'webserver'
description 'webserver'
run_list 'nginx::source'
default_attributes({
  :nginx => {
    :version => "1.4.0",
    :dir => '/etc/nginx',
    :log_dir => '/var/log/nginx',
    :gzip => "on",
    :gzip_comp_level => 4,
    :gzip_http_version => "1.1",
    :source => {
      :url => "http://nginx.org/download/nginx-1.4.0.tar.gz",
      :modules => [
        "upload_progress_module",
        "http_echo_module"
      ]
    }
  }
})
