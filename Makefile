all: build run

pico-8/pico8:
	$(error You need to install pico8 into the ./pico-8 directory!)

utils/lua2pico.lua:
	git submodule init
	git submodule update

build: utils
	@mkdir -p build
	@utils/lua2pico.lua src/main.lua src/cart.p8 > build/picoverse.p8

run: build pico-8/pico8
	@cp build/picoverse.p8 pico-8/__tmp__.p8
	@cd pico-8; ./pico8 -run __tmp__.p8; rm __tmp__.p8

.PHONY: build