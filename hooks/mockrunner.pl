#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: struts-taglib'."\n");
    $jpp->get_section('build')->unshift_body_after(qr'build-classpath struts',
'ln -sf $(build-classpath struts-extras)
ln -sf $(build-classpath struts-taglib)
');
}
__END__
