#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->add_patch('apache-commons-daemon-e2k.patch',STRIP=>1,INSERT_BEFORE=>'^cd\s');
};

__END__
