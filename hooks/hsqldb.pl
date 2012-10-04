#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('hsqldb-1.8.0.7-alt-init.patch',STRIP=>1);

};

__END__
