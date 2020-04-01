sources = files('plank-initial-setup.vala')

executable('plank-initial-setup', sources,
           dependencies: [dependencies, conf_dep],
           install: true,
           install_dir: join_paths('prefix', get_option('libexecdir')))
