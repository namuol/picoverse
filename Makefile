all: build run

pico-8/pico8:
	$(error You need to install pico8 into the ./pico-8 directory!)

utils/lua2pico.lua:
	git submodule init
	git submodule update

src/ecs/ecs.lua:
	git submodule init
	git submodule update	

build: utils utils/lua2pico.lua src/ecs/ecs.lua
	@mkdir -p build
	@utils/png2pico.lua src/gfx.png src/cart.p8 > .tmp0.p8
	@./png2map.lua src/map.png .tmp0.p8 > .tmp.p8
	@utils/pack.lua src | utils/lua2pico.lua - .tmp.p8 > build/cart.p8
	@rm .tmp.p8 .tmp0.p8

run: pico-8/pico8 build
	@cd pico-8; ln -s ../build/cart.p8 .; ./pico8 -run cart.p8; unlink cart.p8

.PHONY: build