#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->source_apply_patch(SOURCEFILE=>'bouncycastle-pg-1.46-01-build.xml', PATCHFILE=>'bouncycastle-pg-1.46-01-build.xml.patch');
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-junit4'."\n");
};

__END__
