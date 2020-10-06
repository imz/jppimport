#!/usr/bin/perl -w

push @SPECHOOKS,
sub {
    my ($spec,) = @_;
    foreach my $sec ($spec->get_sections()) {
	next if $sec->get_type ne 'package';
	$sec->map_body(sub {
    $_='' if /^(?:Provides|Obsoletes):/;
    });
    }
};

__END__
