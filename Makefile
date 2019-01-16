# coldmvc - Makefile last updated 
PREFIX = /usr/local
SHAREDIR = $(PREFIX)/share
MANDIR = ${PREFIX}/share/man
BINDIR = $(PREFIX)/bin
CONFIG = /etc
WILDCARD=*
NAME=coldmvc


# list - List all the targets and what they do
list:
	@printf 'Available options are:\n'
	@sed -n '/^#/ { s/# //; 1d; p; }' Makefile | awk -F '-' '{ printf "  %-20s - %s\n", $$1, $$2 }'

# install - Install the ColdMVC package on a new system
install:
	-test -d $(PREFIX) || mkdir -p $(PREFIX)/{share,share/man,bin}/
	-mkdir -p $(PREFIX)/share/$(NAME)/
	-cp ./$(NAME) $(PREFIX)/bin/$(NAME)
	-cp -r ./share/$(WILDCARD) $(PREFIX)/share/$(NAME)/
	-cp ./$(NAME).cfc $(PREFIX)/share/$(NAME)/
	-cp ./etc/$(NAME).conf $(CONFIG)/
	-sed -i 's;__PREFIX__;$(PREFIX);' $(CONFIG)/$(NAME).conf 

# uninstall - Uninstall the ColdMVC package on a new system
uninstall:
	-rm -f $(PREFIX)/bin/$(NAME)
	-rm -f $(CONFIG)/$(NAME).conf
	-rm -rf $(PREFIX)/share/$(NAME)/

#if 0 
# usermake - Create a modified Makefile for regular users
pkgMakefile:
	@sed '/^# /d' Makefile | cpp - | sed '/^# /d'


# pkg - Create new packages for distribution
pkg:
	git archive master HEAD | tar czf - > /tmp/$(NAME).`date +%F`.`date +%H-%M-%S`.tar.gz


# testprojects - Generate projects that stress test Apache proxy and Lucee standalone installs
testprojects: VH_TEST=testvh
testprojects: SA_TEST=testsa
testprojects: LUCEE_DIR=/opt/lucee/tomcat/webapps
testprojects:
	$(NAME) --create --basedir $(SA_TEST) --folder $(LUCEE_DIR)/$(SA_TEST) \
		--name $(SA_TEST)
	$(NAME) --create --folder /srv/http/$(VH_TEST) --name $(VH_TEST)


# testinit - Make sure the dev system is setup to run some tests
testinit:
	systemctl restart httpd
	systemctl restart lucee
	test -z "`grep 'testvh.local' /etc/hosts`" && \
		printf "127.0.0.1\ttestvh.local\twww.testvh.local\n" >> /etc/hosts || \
		printf '' >/dev/null


#endif
