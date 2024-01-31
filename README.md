# vig
V ImGui module -- dear imgui / cimgui wrapper

If you are new to dear imgui see [here](https://github.com/ocornut/imgui)
If you are new to cimgui see [here](https://github.com/cimgui/cimgui)

Current APIs available/tested in examples :
- create SDL2 / OpenGL window
- set clear color
- create ImGui subwindows
- create widgets : buttons, slider, text inputs, color picker, etc...
- persistent layout
- debug tools : FPS, stats, etc..

# Examples

See in examples/mainig_v/mainig_v.v
This is a V port of ImGui example_sdl2_opengl3

How to test `vig` on linux : (prerequisite : v is already installed and in the PATH)
```
$ v install nsauzede.vsdl2
$ v install nsauzede.vig
$ cd ~/.vmodules/nsauzede/vig
$ make
$ LD_LIBRARY_PATH=. v run examples/mainig/mainig.v
```

There is also a hot-reload mode (-live) :
```
$ cd ~/.vmodules/nsauzede/vig
$ LD_LIBRARY_PATH=. v -live run examples/mainig/mainig.v
```
In hot-reload mode, once the vig demo windows is shown, try to modify the `live_main` function (tagged with `[live]`)
to see the "live" changes appearing a few instants after saving the source file.
Enjoy !

# Dependencies
Ubuntu :
`$ sudo apt install git cmake libsdl2-dev libglew-dev`

ClearLinux :
`$ sudo swupd bundle-add git cmake devpkg-SDL2 devpkg-glew`

Windows/MSYS2 :
`$ pacman -S msys/git mingw64/mingw-w64-x86_64-cmake mingw64/mingw-w64-x86_64-SDL2 mingw64/mingw-w64-x86_64-glew`
