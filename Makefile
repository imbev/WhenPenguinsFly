CC = clang
CFLAGS = \
	-std=c23 \
	-Wno-c23-extensions \
	-I include \
	-I vendor/include
LDLIBS = \
	-L vendor/lib \
	-lm \
	-lSDL3 \
	-lSDL3_image
headers = \
	./vendor/include/SDL3/SDL.h \
	./vendor/include/SDL3_image/SDL_image.h \
	include/assets.h
objects = \
	src/assets.o \
	vendor/lib/libSDL3_image.a \
	vendor/lib/libSDL3.a

SDL3_VERSION = 3.2.22
SDL3_IMAGE_VERSION = 3.2.4

when_penguins_fly: when_penguins_fly.c $(headers) $(objects)
	$(CC) $(CFLAGS) $(LDLIBS) $^
	@mv a.out $@

./vendor/sdl.tar.gz:
	mkdir -p ./vendor
	curl -L -o ./vendor/sdl.tar.gz https://github.com/libsdl-org/SDL/archive/refs/tags/release-$(SDL3_VERSION).tar.gz

./vendor/include/SDL3/SDL.h: ./vendor/sdl.tar.gz
	mkdir -p ./vendor/include
	-rm -rf SDL*
	tar -xf ./vendor/sdl.tar.gz
	cp -r SDL*/include/SDL3 ./vendor/include
	rm -rf SDL*

./vendor/lib/libSDL3.a: ./vendor/sdl.tar.gz
	mkdir -p ./vendor/build/sdl ./vendor/lib
	-rm -rf ./vendor/build/sdl/.
	-rm -rf SDL*
	tar -xf ./vendor/sdl.tar.gz
	cp -r SDL*/. ./vendor/build/sdl/
	rm -rf SDL*
	cd ./vendor/build/sdl/ && \
		CC=$(CC) cmake . -DSDL_STATIC=ON -DSDL_SHARED=off -DSDLIMAGE_VENDORED=ON
	cd ./vendor/build/sdl/ && \
		cmake --build . --config Release
	cp ./vendor/build/sdl/libSDL3.a ./vendor/lib/
	rm -rf ./vendor/build/sdl/

./vendor/sdl_image.tar.gz:
	mkdir -p ./vendor
	curl -L -o ./vendor/sdl_image.tar.gz https://github.com/libsdl-org/SDL_image/releases/download/release-$(SDL3_IMAGE_VERSION)/SDL3_image-$(SDL3_IMAGE_VERSION).tar.gz

./vendor/include/SDL3_image/SDL_image.h: ./vendor/sdl_image.tar.gz
	mkdir -p ./vendor/include
	-rm -rf SDL*_image*
	tar -xf ./vendor/sdl_image.tar.gz
	cp -r SDL*_image*/include/SDL3_image ./vendor/include
	rm -rf SDL*_image*

./vendor/lib/libSDL3_image.a: ./vendor/sdl_image.tar.gz
	mkdir -p ./vendor/build/sdl ./vendor/lib
	-rm -rf ./vendor/build/sdl_image/.
	-rm -rf SDL*_image*
	tar -xf ./vendor/sdl_image.tar.gz
	cp -r SDL*_image*/. ./vendor/build/sdl_image
	rm -rf SDL*_image*
	cd ./vendor/build/sdl_image/ && \
		CC=$(CC) cmake . -DBUILD_SHARED_LIBS=OFF
	cd ./vendor/build/sdl_image/ && \
		cmake --build . --config Release
	cp vendor/build/sdl_image/libSDL3_image.a ./vendor/lib/
	rm -rf ./vendor/build/sdl_image/

clean:
	-rm \
		when_penguins_fly \
		./include/*.gch \
		./include/*.pch \
		./src/*.o

clean-vendor:
	-rm -rf ./vendor
