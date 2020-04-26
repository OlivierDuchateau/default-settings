skeleton = 'io.elementary.pantheon.AccountsService'

polkit_dir = join_paths(prefix, get_option('datadir'),
                        'polkit-1', 'actions')
install_data(skeleton + '.policy',
             install_dir: polkit_dir)

dbus_dir = join_paths(prefix, get_option('datadir'),
                      'dbus-1', 'interfaces')
install_data(skeleton + '.xml',
             install_dir: dbus_dir)

acc_dir = join_paths(prefix, get_option('datadir'),
                     'accountsservice', 'interfaces')

meson.add_install_script('../meson/post_install.py',
                         skeleton + '.xml', dbus_dir, acc_dir)
