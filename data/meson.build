autostart_dir = join_paths(prefix, get_option('sysconfdir'),
                           'xdg', 'autostart')

desktop_conf = configuration_data()
desktop_conf.set('libexec_dir', libexec_dir)
configure_file(input: 'plank-initial-setup.desktop.in',
               output: 'plank-initial-setup.desktop',
               configuration: desktop_conf,
			   install_dir: autostart_dir)

install_data('settings.ini',
             install_dir: join_paths(prefix, get_option('sysconfdir'),
                                     'gtk-3.0'))
