#!/usr/bin/perl -w

push @PREHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->main_section->map_body(
    sub {
	if (m'^Requires:') {
	    s!java-headless,?\s*!!;
	    s!jpackage-utils,?\s*!!;
	}
    });
};

__END__
