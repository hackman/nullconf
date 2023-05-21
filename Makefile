parts = templates/header.tmpl templates/footer.tmpl
work = templates/workshops.tmpl $(parts)
pages = index.html about.html workshops.html contact.html program.html
destination = yuhu.biz:nullconf.ca/

# Do not print the executed commands
.SILENT:

pull:
	git pull

all: pull $(pages)

index.html: templates/index.tmpl $(parts)
	sed 's/__$@__/active/;s/__[a-z]\+__//;s/ __SUB__//' templates/header.tmpl > $@
	cat templates/$(basename $@).tmpl templates/footer.tmpl >> $@
	printf "%16s done\n" $@

%.html: $(parts) templates/%.tmpl
	sed 's/__$(basename $@)__/active/;s/__[a-z]\+__//;s/ __SUB__/ class="sub_page"/' templates/header.tmpl > $@
	cat templates/$(basename $@).tmpl templates/footer.tmpl >> $@
	printf "%16s done\n" $@

clean:
	rm -f $(pages)

push: all
	rsync --exclude=tmp --exclude='Makefile*' --exclude='*~' --exclude=templates -aHv * $(destination)
