#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #due to Requires: jlfgr
    $jpp->disable_package('board');
    $jpp->main_section->unshift_body('BuildRequires: geronimo-jta-1.0.1B-api'."\n");
}
__END__
