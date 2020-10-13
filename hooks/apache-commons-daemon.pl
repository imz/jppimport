#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->add_patch('apache-commons-daemon-1.2.0-e2k.patch',STRIP=>1,INSERT_BEFORE=>'^cd\s');
};

__END__
