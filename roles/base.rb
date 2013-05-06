name "base"
description "all server base role"
run_list "recipe[chef-solo-search]", "recipe[users::sysadmins]", "recipe[sudo]", "recipe[openssh]"

default_attributes({
  :authorization => {
    :sudo => {
      :groups => ["sysadmin", "admin", "wheel"],
      :users => ["foo"],
      :passwordless => false,
      :sudoers_defaults => [
        '!visiblepw',
        'env_reset',
        'env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"',
        'env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"',
        'env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"',
        'env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"',
        'env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"',
        'env_keep += "HOME"',
        'always_set_home',
        'secure_path = /sbin:/bin:/usr/sbin:/usr/bin'
      ]
    }
  },
  :openssh => {
    :server => {
      :password_authentication => "no"
    }
  }
})
