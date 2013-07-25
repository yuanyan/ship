DIR_NW=node-webkit
DIR_DOWNLOADS=downloads

DIR_WIN=$(DIR_NW)/win
DIR_L32=$(DIR_NW)/l32
DIR_L64=$(DIR_NW)/l64
DIR_MAC=$(DIR_NW)/mac

NW_VERSION=0.6.3
URL_CDN=https://s3.amazonaws.com/node-webkit/v$(NW_VERSION)/
ARCHIVE_WIN=node-webkit-v$(NW_VERSION)-win-ia32.zip
ARCHIVE_L32=node-webkit-v$(NW_VERSION)-linux-ia32.tar.gz
ARCHIVE_L64=node-webkit-v$(NW_VERSION)-linux-x64.tar.gz
ARCHIVE_MAC=node-webkit-v$(NW_VERSION)-osx-ia32.zip

ARCHIVES=$(ARCHIVE_WIN) $(ARCHIVE_L32) $(ARCHIVE_L64) $(ARCHIVE_MAC)
URLS=$(addprefix $(URL_CDN),$(ARCHIVES))

DEP_DOWNLOADED=$(addprefix $(DIR_DOWNLOADS)/,$(ARCHIVES))


# test:
#     @echo $(DEP_DOWNLOADED)
#     @echo $(URLS)

all: nw installjammer

nw: $(DIR_L32) $(DIR_L64) $(DIR_WIN) $(DIR_MAC)

installjammer/:
    wget -c http://sourceforge.net/projects/installjammer/files/latest/download \
        -O installjammer.tgz
    tar -xvzf installjammer.tgz

$(DIR_MAC)/: $(DIR_DOWNLOADS)/$(ARCHIVE_MAC)
    mkdir -p $(DIR_NW)
    unzip $<
    rm -rfv $(DIR_MAC)
    mv node-webkit.app $(DIR_MAC)

$(DIR_WIN)/: $(DIR_DOWNLOADS)/$(ARCHIVE_WIN)
    mkdir -p $(DIR_NW)
    unzip $<
    rm -rfv $(DIR_WIN)
    mv node-webkit-v$(NW_VERSION)-win-ia32 $(DIR_WIN)

$(DIR_L32)/: $(DIR_DOWNLOADS)/$(ARCHIVE_L32)
    mkdir -p $(DIR_NW)
    tar xvzf $<
    rm -rfv $(DIR_L32)
    mv node-webkit-v$(NW_VERSION)-linux-ia32 $(DIR_L32)

$(DIR_L64)/: $(DIR_DOWNLOADS)/$(ARCHIVE_L64)
    mkdir -p $(DIR_NW)
    tar xvzf $<
    rm -rfv $(DIR_L64)
    mv node-webkit-v$(NW_VERSION)-linux-x64 $(DIR_L64)

download: $(DEP_DOWNLOADED)

$(DEP_DOWNLOADED):
    @mkdir -p $(DIR_DOWNLOADS) && cd $(DIR_DOWNLOADS) && \
    for u in $(URLS); do wget -c $$u; done

.PHONY: download nw