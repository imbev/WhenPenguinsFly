project(
  'WhenPenguinsFly',
  'c',
  meson_version : '>= 1.3.0',
  version : '0.1',
  default_options : ['warning_level=3'],
)

dependencies = [
  dependency('sdl3'),
  dependency('sdl3-image'),
  dependency('sdl3-ttf')
]

exe = executable(
  'WhenPenguinsFly',
  [
    'src/main.c',
    'src/button.c'
  ],
  dependencies : dependencies,
  install : true,
)
