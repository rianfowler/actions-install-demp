# Default version to test
VERSION ?= 0.1.6

.PHONY: test clean

test:
	@echo "Testing install-demp.sh with version $(VERSION)..."
	# For local testing, you might want to remove the sudo or change the target path.
	./install-demp.sh $(VERSION)

clean:
	@echo "Cleaning up downloaded files..."
	# Remove the downloaded tarball, checksum file, and extracted binary if present.
	rm -f demp_$(VERSION)_* demp $(CHECKSUM_NAME)