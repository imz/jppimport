#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->applied_block(
	"fix Provides foo < x.y hook",
	sub {
	    foreach my $sec ($spec->get_sections()) {
		next if $sec->get_type ne 'package';
		$sec->map_body(sub {
		    s,(\s)<(\s),$1=$2,g if /^Provides:/i
			       });
	    }
	});
};

__END__
