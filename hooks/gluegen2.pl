#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body(q'%filter_from_requires /.opt-share.etc.profile.ant/d'."\n");
};

__END__
