DOCKER_IMG := openwrt_bbb:1.0
DOCKER_CONTAINER := bbb_img_builder
DOCKER_BUILD_CONTEXT := .

OUTPUT_DIR := ./output



build:
	sudo docker build -t $(DOCKER_IMG) $(DOCKER_BUILD_CONTEXT)

get: 
	sudo docker run --name $(DOCKER_CONTAINER) --rm -v $(OUTPUT_DIR):/output_volume $(DOCKER_IMG)

flash: 
	gunzip -kf $(OUTPUT_DIR)/openwrt-omap-generic-ti_am335x-bone-black-ext4-sdcard.img.gz
	sudo dd if=$(OUTPUT_DIR)/openwrt-omap-generic-ti_am335x-bone-black-ext4-sdcard.img of=/dev/sdb bs=1M

clean: 
	@rm -rf $(OUTPUT_DIR)/*
