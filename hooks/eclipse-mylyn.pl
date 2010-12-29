#!/usr/bin/perl -w
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->subst(qr'ws-commons-util-1.0.1.jar','ws-commons-util.jar');
    $jpp->get_section('install')->subst(qr'ws-commons-util-1.0.1.jar','ws-commons-util.jar');
};
__END__
pushd $RPM_BUILD_ROOT%{install_loc}/mylyn/eclipse/plugins
rm org.apache.commons.codec_*.jar
rm org.apache.commons.httpclient_3.1.0.v20080605-1935.jar
rm org.apache.commons.lang_2.*.jar
rm org.apache.commons.logging_1.*
