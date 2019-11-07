# Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file.

TARGET:=
TARGET+=cimgui.so
TARGET+=cimgui.h
TARGET+=imgui_impl_sdl.o
TARGET+=imgui_impl_opengl3.so
CP:=cp
CIMGUI:=cimgui
IMGUI:=$(CIMGUI)/imgui
CFLAGS:=-I.
CFLAGS+=-DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=1
CFLAGS+=-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1
CFLAGS+=-DIMGUI_IMPL_API=
CFLAGS+=`sdl2-config --cflags`
LDFLAGS+=`sdl2-config --libs`
LDFLAGS+=-lGL -lGLEW

all: $(TARGET)

cimgui.so: cimgui/bld/cimgui.so
	$(CP) $< $@

cimgui.h: cimgui/bld/cimgui.so
	$(CP) cimgui/cimgui.h $@

cimgui/bld/cimgui.so:
	[ -d cimgui ] || git clone --recursive https://github.com/cimgui/cimgui.git
	(export CFLAGS= CXXFLAGS= ; cd cimgui ; mkdir bld ; cd bld ; cmake .. ; make)

imgui_impl_sdl.o: $(IMGUI)/examples/imgui_impl_sdl.cpp
	$(CXX) -fPIC -c -o $@ $^ -I$(IMGUI) `sdl2-config --cflags` -DIMGUI_IMPL_API=extern\ \"C\" -fno-threadsafe-statics

imgui_impl_opengl3.o: $(IMGUI)/examples/imgui_impl_opengl3.cpp
	$(CXX) -fPIC -c -o $@ $^ -I$(IMGUI) -DIMGUI_IMPL_API=extern\ \"C\" -fno-threadsafe-statics

imgui_impl_opengl3.so: imgui_impl_opengl3.o
	$(CXX) -shared -o $@ $^

clean:
	$(RM) *.o *.so $(TARGET)

clobber: clean
	$(RM) -Rf cimgui
	$(RM) imgui.ini
