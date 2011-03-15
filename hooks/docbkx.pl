#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-shared-ant'."\n");
    $jpp->add_patch('docbkx-2.0.8-alt-AntPropertyHelper.patch', STRIP => 1);
};
__END__
