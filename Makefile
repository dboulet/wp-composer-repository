package_name=wordpress/wordpress
versions=$(shell curl "https://api.github.com/repos/WordPress/WordPress/tags" | jq -r ".[] | .name")

docs/packages.json:
	@mkdir -p $(@D)
	@> $@
	@echo '{' >> $@
	@echo '  "packages": {' >> $@
	@echo '    "${package_name}": {' >> $@
	@for v in ${versions}; do \
	echo '      "'$$v'": {' >> $@ ; \
	echo '      	"name": "${package_name}",' >> $@ ; \
	echo '        "type": "webroot",' >> $@ ; \
	echo '        "version": "'$$v'",' >> $@ ; \
	echo '        "dist": {' >> $@ ; \
	echo '          "url": "https://wordpress.org/wordpress-'$$v'-no-content.zip",' >> $@ ; \
	echo '          "type": "zip"' >> $@ ; \
	echo '        },' >> $@ ; \
	echo '        "source": {' >> $@ ; \
	echo '          "url" : "https://github.com/WordPress/WordPress",' >> $@ ; \
	echo '          "type": "git",' >> $@ ; \
	echo '          "reference": "'$$v'"' >> $@ ; \
	echo '        },' >> $@ ; \
	echo '        "require": {' >> $@ ; \
	echo '          "fancyguy/webroot-installer": "^1.0"' >> $@ ; \
	echo '        }' >> $@ ; \
	echo '      },' >> $@ ; \
	done
	@sed -i '' -e '$$ s/},/}/' $@
	@echo '    }' >> $@
	@echo '  }' >> $@
	@echo '}' >> $@

clean:
	@rm -rf docs

check: docs/packages.json
	@cat $^ | jq

.PHONY: clean check
