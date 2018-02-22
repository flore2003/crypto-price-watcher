project('com.github.flore2003.cryptonian', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

data_res = gnome.compile_resources(
  'crypto-watcher-icon-resources',
  files('data/data.gresource.xml'),
  source_dir: [ join_paths(meson.source_root(), 'data') ]
)

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/DataService.vala',
    'src/Models/Coin.vala',
    'src/Widgets/CoinEntry.vala',
    data_res,
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('gtk+-3.0'),
        dependency('gee-0.8'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        dependency('appindicator3-0.1'),
        meson.get_compiler('c').find_library('m', required : false)
    ],
    install: true
)