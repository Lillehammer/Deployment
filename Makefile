
CURRENT_DATE := $(shell date +%s)

PRE_TARGETS = make -C ../Mission && make -C ../Economy

BUILD = bin/build.sh "$(@)" "$(CURRENT_DATE)"

RELEASE = bin/release.sh "/cygdrive/d/CYGWIN_RELEASES/$(@)/$(CURRENT_DATE)" "$(@)"

all:

tmp:
	mkdir -pv $(@)

pre_targets:
	$(PRE_TARGETS)

testing: pre_targets
	$(BUILD)
	$(RELEASE)

production: pre_targets
	$(BUILD)
	$(RELEASE)

clean:
	rm -rfv tmp
	rm -rfv /cygdrive/d/CYGWIN_RELEASES/testing
