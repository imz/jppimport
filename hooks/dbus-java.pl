#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: /usr/bin/xsltproc'."\n");
    $spec->get_section('files','')->map_body(
    sub {
	    if (/^\%doc.*man1/) {
		s,\%_mandir/man1,%_man1dir,;
		s,\.gz,.*,;
	    }
    }
    );
};

__END__
