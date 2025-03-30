# Default version to test
VERSION ?= 0.1.13
KEY_ID ?= 092017BA1C395379

.PHONY: test clean

test:
	@echo "Testing install-demp.sh with version $(VERSION)..."
	# For local testing, you might want to remove the sudo or change the target path.
	./install-demp.sh $(VERSION) $(KEY_ID)

clean:
	@echo "Cleaning up downloaded files..."
	# Remove the downloaded tarball, checksum file, and extracted binary if present.
	rm -f demp_$(VERSION)_* demp $(CHECKSUM_NAME)
	rm $(which demp)