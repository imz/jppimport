#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('gmaven-1.3-alt-fix-build.patch',STRIP=>1);
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-parent'."\n");

};

__END__
