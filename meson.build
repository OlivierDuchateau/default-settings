project('elementary-settings',
        'c', 'vala',
        version: '5.1.2.1')

prefix = get_option('prefix')
libexec_dir = join_paths(prefix, get_option('libexecdir'))
data_dir = join_paths(prefix, get_option('datadir'))

vapi_dir = join_paths(meson.current_source_dir(), 'vapi')
add_project_arguments(['--vapidir', vapi_dir],
                      language: 'vala')

dependencies = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	dependency('gio-2.0'),
	dependency('accountsservice')]

conf_data = configuration_data()
conf_data.set('install_prefix', prefix)
config_file = configure_file(input: 'config.vala.in',
                             output: 'config.vala',
                             configuration: conf_data)

conf_dep = declare_dependency(sources: config_file,
                              include_directories: include_directories('.'))

subdir('src')
subdir('data')
subdir('launchers')
subdir('accountsservice')
