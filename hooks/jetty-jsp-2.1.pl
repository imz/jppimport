#!/usr/bin/perl -w

#die;

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # BuildRequires:\s+fedora-usermgmt-devel
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-release maven-plugin-bundle'."\n");
}
__END__
