#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('apache-commons-validator-1.4-alt-make-oro-essential-dependency.patch',STRIP=>0);
};

__END__
