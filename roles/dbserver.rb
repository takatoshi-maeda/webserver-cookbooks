name 'dbserver'
description 'mysql db server role'
run_list 'recipe[mysql::server]'
default_attributes({
  :mysql => {
    :remove_test_database => true
  }
})
