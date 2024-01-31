# Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file.

TARGET:=
TARGET+=cimgui.so
TARGET+=cimgui.h
TARGET+=imgui_impl_sdl2.o
#TARGET+=imgui_impl_opengl3.so
TARGET+=libcimgui.a
TARGET+=libcimgui.so
CP:=cp
AR:=ar
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

CIG_OBJS=$(wildcard cimgui/bld/CMakeFiles/cimgui.dir/imgui/*.cpp.o)
#cimgui.a: $(CIG_OBJS) imgui_impl_sdl2.o imgui_impl_opengl3.o cimgui/bld/CMakeFiles/cimgui.dir/cimgui.cpp.o
libcimgui.a: imgui_impl_sdl2.o imgui_impl_opengl3.o cimgui/bld/CMakeFiles/cimgui.dir/cimgui.cpp.o $(CIG_OBJS)
	$(AR) cr $@ $^

libcimgui.so: imgui_impl_sdl2.o imgui_impl_opengl3.o cimgui/bld/CMakeFiles/cimgui.dir/cimgui.cpp.o $(CIG_OBJS)
	$(CXX) -shared -o $@ $^

cimgui.h: cimgui/bld/cimgui.so
	$(CP) cimgui/cimgui.h $@

cimgui/bld/cimgui.so:
	[ -d cimgui ] || git clone --recursive https://github.com/cimgui/cimgui.git
	(export CFLAGS= CXXFLAGS= ; cd cimgui ; mkdir bld ; cd bld ; cmake .. ; make)

imgui_impl_sdl2.o: $(IMGUI)/backends/imgui_impl_sdl2.cpp
	$(CXX) -fPIC -c -o $@ $^ -I$(IMGUI) `sdl2-config --cflags` -DIMGUI_IMPL_API=extern\ \"C\" -fno-threadsafe-statics

imgui_impl_opengl3.o: $(IMGUI)/backends/imgui_impl_opengl3.cpp
	$(CXX) -fPIC -c -o $@ $^ -I$(IMGUI) -DIMGUI_IMPL_API=extern\ \"C\" -fno-threadsafe-statics

imgui_impl_opengl3.so: imgui_impl_opengl3.o
	$(CXX) -shared -o $@ $^

clean:
	$(RM) *.o *.so $(TARGET)

clobber: clean
	$(RM) -Rf cimgui
	$(RM) imgui.ini
