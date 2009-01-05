#!/usr/bin/perl -w
push @SPECHOOKS, sub {
    ## $spec is RPM::Source::Editor object.
    ## $section is RPM::Source::SpecSection object.
    my ($spec, $pkgname) = @_;
    my $section=$spec->get_section('install');
    unless ($section) {
	print STDERR "Oops! install section not found!\n";
    } elsif (not $section->match(qr'# It is the file in the package named Thumbs.db or Thumbs.db.gz')) {
	$section->push_body(q!
# It is the file in the package named Thumbs.db or Thumbs.db.gz, 
# which is normally a Windows image thumbnail database. 
# Such databases are generally useless in packages and were usually 
# accidentally included by copying complete directories from the source tarball.
find $RPM_BUILD_ROOT \( -name 'Thumbs.db' -o -name 'Thumbs.db.gz' \) -print -delete
!);
    }
};

