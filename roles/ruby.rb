name 'ruby'
description 'ruby env'
run_list 'recipe[ruby_build]', 'recipe[rbenv::system_install]', 'recipe[rbenv::system]'
default_attributes({
  :rbenv => {
    :upgrade => true,
    :global => "1.9.3-p392",
    :version => "1.9.3-p392",
    :rubies => [
      '1.9.3-p392',
      '2.0.0-p0'
    ],
    :gems => {
      "1.9.3-p392" => [
        {:name => "bundler"}
      ],
      "2.0.0-p0" => [
        {:name => "bundler"}
      ]
    }
  }
})
