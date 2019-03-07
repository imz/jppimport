#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('%filter_from_requires /^java-headless/d'."\n");
    # bootstrap packages
    $spec->applied_off;
    $spec->main_section->exclude_body(qr'^Requires:\s+java-headless');
    $spec->applied_on;
};

__END__
