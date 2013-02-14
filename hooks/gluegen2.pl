#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst_body(qr'/junit.jar','/junit4.jar');
    $jpp->get_section('build')->subst_body(qr'/ant-junit.jar','/ant-junit4.jar');
    $jpp->get_section('package','')->subst_body_if(qr'ant-junit','ant-junit4',qr'^BuildRequires');
    $jpp->get_section('package','')->unshift_body(q'%filter_from_requires /.opt-share.etc.profile.ant/d'."\n");
};

__END__
