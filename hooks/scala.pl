#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('files','')->push_body('%dir %_datadir/scala/lib'."\n");
};

__END__
