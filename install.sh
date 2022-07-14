#!/bin/ksh

PREFIX=/usr/local

main() {
	progname="$1"
	section="$2"
	bindir=$PREFIX/bin
	mandir=$PREFIX/share/man/man$section

	echo "Making appropriate directories under $PREFIX ..."
	test -d $bindir || mkdir -p -m 775 $bindir
	test -d $mandir || mkdir -p -m 775 $mandir
	echo "Installing main script..."
	install -m 775 -o root -g bin "$progname" $bindir
	echo "Installing user manpage..."
	install -m 664 -o root -g bin $progname.$section $mandir
	echo "Done."
}

main "$@"

