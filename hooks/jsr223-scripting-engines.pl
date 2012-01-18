#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('jsr223-scripting-engines-alt-patch-bsh-2.1.patch',STRIP=>0);
};

__END__
