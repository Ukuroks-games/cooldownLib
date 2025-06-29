LIBNAME = cooldown

PACKAGE_NAME = $(LIBNAME)lib.zip

CP = cp -rf
MV = mv -f
RM = rm -rf

./build: 
	mkdir build
	
configure: ./build wally.toml src/*
	$(CP) src/* build/
	$(MV) build/$(LIBNAME).lua build/init.lua
	$(CP) wally.toml build/

package: configure
	wally package --output $(PACKAGE_NAME) --project-path build

publish: configure
	wally publish --project-path build

lint:
	selene src/ tests/

clean: 
	$(RM) -rf build $(PACKAGE_NAME)
