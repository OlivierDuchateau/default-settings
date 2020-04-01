launcher_files = ['gala-multitaskingview.dockitem',
                  'com.github.cassidyjames.ephemeral.dockitem',
                  'io.elementary.calendar.dockitem',
                  'io.elementary.music.dockitem',
                  'io.elementary.terminal.dockitem',
                  'io.elementary.videos.dockitem',
                  'io.elementary.photos.dockitem',
                  'io.elementary.switchboard.dockitem']

launcher_conf = configuration_data()
launcher_conf.set('data_dir', join_paths(prefix, get_option('datadir')))

plank_launchers_dir = join_paths(prefix, get_option('datadir'),
                                 'plank', 'launchers')

foreach launcher: launcher_files
	configure_file(input: launcher + '.in',
                   output: launcher,
                   configuration: launcher_conf,
                   install_dir: plank_launchers_dir)
endforeach
