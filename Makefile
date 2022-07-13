
PROG    = phosphor
SECTION = 6
PODOPTS = --release=' ' --center=' ' --date=`date +%Y-%m-%d` \
	  --quotes=none --section=$(SECTION) --name=$(PROG)

.DEFAULT_GOAL := help

# Automatic self-documentation
.PHONY: help # See https://tinyurl.com/makefile-autohelp
help: ## Print help for each target
	@awk -v tab=10 'BEGIN{FS="(:.*## |##@ |@## )";c="\033[36m";m="\033[0m";y="  ";a=2;h()}function t(s){gsub(/[ \t]+$$/,"",s);gsub(/^[ \t]+/,"",s);return s}function u(g,d){split(t(g),f," ");for(j in f)printf"%s%s%-"tab"s%s%s\n",y,c,t(f[j]),m,d}function h(){printf"\nUsage:\n%smake %s<target>%s\n\nRecognized targets:\n",y,c,m}/\\$$/{gsub(/\\$$/,"");b=b$$0;next}b{$$0=b$$0;b=""}/^[-a-zA-Z0-9*\/%_. ]+:.*## /{p=sprintf("\n%"(tab+a)"s"y,"");gsub(/\\n/,p);if($$1~/%/&&$$2~/^%:/){n=split($$2,q,/%:|:% */);for(i=2;i<n;i+=2){g=$$1;sub(/%/,q[i],g);u(g,q[i+1])}}else if($$1~/%/&&$$2~/%:[^%]+:[^%]+:%/){d=$$2;sub(/^.*%:/,"",d);sub(/:%.*/,"",d);n=split(d,q,/:/);for(i=1;i<=n;i++){g=$$1;d=$$2;sub(/%/,q[i],g);sub(/%:[^%]+:%/,q[i],d);u(g,d)}}else u($$1,$$2)}/^##@ /{gsub(/\\n/,"\n");if(NF==3)tab=$$2;printf"\n%s\n",$$NF}END{print""}' $(MAKEFILE_LIST) # v1.62

.PHONY: all
all: mandoc ## Generate manpage (all formats)

.PHONY: man
man: $(PROG).$(SECTION) ## Generate manpage (nroff format)

.PHONY: mandoc
mandoc: $(PROG).pdf ## Generate manpage (ps and pdf format)

.PHONY: readman
readman: $(PROG).$(SECTION) ## Display the manpage
	man ./$(PROG).$(SECTION)

.PHONY: mandemo
mandemo: $(PROG).$(SECTION) ## Animate the manpage
	@man ./$(PROG).$(SECTION) | ./phosphor -c r -br 0

$(PROG).$(SECTION): $(PROG)
	pod2man $(PODOPTS) $< | sed 's/@(#)ms.acc/ms.acc/' > $@

$(PROG).ps: $(PROG).$(SECTION)
	groff -man -Tps $< > $@

$(PROG).pdf: $(PROG).ps
	ps2pdf $<

.PHONY: install
install: $(PROG) ## Copy script and manpage to system directories
	./install.sh $(PROG) $(SECTION)

.PHONY: clean
clean: ## Remove the manpages from the current directory
	rm -f $(PROG).$(SECTION) $(PROG).ps $(PROG).pdf

