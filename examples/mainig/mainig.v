// V standalone example application for dear imgui + SDL2 + OpenGL
// based on ImGui & cimgui examples
// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE_v.txt file.
module main
import nsauzede.vsdl2
import nsauzede.vig
//import os
//#import time

struct AppState{
	show_demo_window bool
	clear_color vig.ImVec4
	size0 vig.ImVec2
	f f32
	mut:
	done bool
	show_another_window bool
	counter int
	io &vig.ImGuiIo = voidptr(0)
	window voidptr
}

fn new_app_state() AppState {
	return AppState{
		show_demo_window: false,
		show_another_window: false,
		clear_color: vig.ImVec4{0.45, 0.55, 0.60, 1.00},
		size0: vig.ImVec2 {0, 0},
		f: 0.0,
		counter: 0,
		done: false,
	}
}

fn setup_main_loop() {
	mut state := new_app_state()
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_AUDIO)
	glsl_version := "#version 130"
	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	C.SDL_GL_SetAttribute(C.SDL_GL_DEPTH_SIZE, 24)
	C.SDL_GL_SetAttribute(C.SDL_GL_STENCIL_SIZE, 8)
	window_flags := C.SDL_WINDOW_OPENGL | C.SDL_WINDOW_RESIZABLE | C.SDL_WINDOW_ALLOW_HIGHDPI
	state.window = C.SDL_CreateWindow(c"Live! V ImGui+SDL2+OpenGL3 demo", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 600, 400, window_flags)
	gl_context := C.SDL_GL_CreateContext(state.window)
	C.SDL_GL_MakeCurrent(state.window, gl_context)
	C.SDL_GL_SetSwapInterval(1) // Enable vsync
	C.glewInit()
	C.igCreateContext(C.NULL)
	state.io = vig.ig_get_io()
	C.igStyleColorsDark(C.NULL)
	C.ImGui_ImplSDL2_InitForOpenGL(state.window, gl_context)
	C.ImGui_ImplOpenGL3_Init(glsl_version.str)
	// Our state
	for !state.done {
		ev := vsdl2.Event{}
		for 0 < C.SDL_PollEvent(&ev) {
			C.ImGui_ImplSDL2_ProcessEvent(&ev)
			match int(unsafe{ev.@type}) {
				C.SDL_QUIT {
					state.done = true
					break
				}
				else {}
			}
		}

        state.imgui_frame()
	}
	// Cleanup => TODO
}

[live]
fn (mut state AppState) imgui_frame(){
	mut size0 := C.ImVec2{}
	size0.x = state.size0.x
	size0.y = state.size0.y
	// Start the Dear ImGui frame
	C.ImGui_ImplOpenGL3_NewFrame()
	C.ImGui_ImplSDL2_NewFrame(state.window)
	C.igNewFrame()
	// 1. Show the big demo window
	if state.show_demo_window {
		C.igShowDemoWindow(&state.show_demo_window)
	}
	// 2. Show a simple window that we create ourselves. We use a Begin/End pair to created a named window.
	{
		C.igBegin(c"Hello, Vorld!", C.NULL, 0)        // Create a window called "Hello, world!" and append into it.
		C.igText(c"This is some useful text.")               // Display some text (you can use a format strings too)
		C.igCheckbox(c"Demo Vindow", &state.show_demo_window)      // Edit bools storing our window open/close state
		C.igCheckbox(c"Another Vindow", &state.show_another_window)
		C.igSliderFloat(c"float", &state.f, 0.0, 1.0, 0, 0)            // Edit 1 float using a slider from 0.0f to 1.0f
		C.igColorEdit3(c"clear color", &state.clear_color, 0) // Edit 3 floats representing a color
//		if C.igButton(c"Button", state.size0) {                            // Buttons return true when clicked (most widgets return true when edited/activated)
		//state.size0.x, state.size0.y}
		if C.igButton(c"Button", size0) {                            // Buttons return true when clicked (most widgets return true when edited/activated)
			state.counter++
		}
		C.igSameLine(0, 0)
		C.igText(c"counter = %d", state.counter)
		C.igText(c"Application average %.3f ms/frame (%.1f FPS)", 1000.0 / state.io.Framerate, state.io.Framerate)
		C.igEnd()
	}
	// 3. Show another simple window.
	if state.show_another_window {
		C.igBegin(c"Another Vindow", &state.show_another_window, 0)   // Pass a pointer to our bool variable (the window will have a closing button that will clear the bool when clicked)
		C.igText(c"Hello from another Vindow!")
//		if C.igButton(c"Close Me", state.size0) {
		if C.igButton(c"Close Me", size0) {
			state.show_another_window = false
		}
		C.igEnd()
	}
	// Rendering
	C.igRender()
	C.glViewport(0, 0, int(state.io.DisplaySize.x), int(state.io.DisplaySize.y))
	C.glClearColor(state.clear_color.x, state.clear_color.y, state.clear_color.z, state.clear_color.w)
	C.glClear(C.GL_COLOR_BUFFER_BIT)
	C.ImGui_ImplOpenGL3_RenderDrawData(C.igGetDrawData())
	C.SDL_GL_SwapWindow(state.window)
}

fn main() {
	setup_main_loop()
}
