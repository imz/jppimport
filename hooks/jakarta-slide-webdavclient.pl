#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->subst(qr's/\@VERSION\@/\%{version_full}-brew','s/@VERSION@/%{version}-brew');
    $jpp->source_apply_patch(PATCHFILE=>'jakarta-slide-webdavclient-component-info.xml-alt.patch',SOURCEFILE=>'jakarta-slide-webdavclient-component-info.xml');
}

__END__
