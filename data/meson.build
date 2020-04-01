autostart_dir = join_paths(prefix, get_option('sysconfdir'),
                           'xdg', 'autostart')
schemas_dir = join_paths(prefix, get_option('datadir'),
                         'glib-2.0', 'schemas')

desktop_conf = configuration_data()
desktop_conf.set('libexec_dir', libexec_dir)
configure_file(input: 'plank-initial-setup.desktop.in',
               output: 'plank-initial-setup.desktop',
               configuration: desktop_conf,
               install_dir: autostart_dir)

schemas_conf = configuration_data()
schemas_conf.set('data_dir', data_dir)
configure_file(input: 'default-settings.gschema.override.in',
               output: '25_elementary.default-settings.gschema.override',
               configuration: schemas_conf,
               install_dir: schemas_dir)

install_data('settings.ini',
             install_dir: join_paths(prefix, get_option('sysconfdir'),
                                     'gtk-3.0'))
