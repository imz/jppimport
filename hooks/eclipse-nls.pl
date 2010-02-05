#!/usr/bin/perl -w

push @PREHOOKS, sub {
    my ($jpp, $alt) = @_;
    # macros body
    $jpp->get_section('description','')->exclude(qr'defattr');
    #$jpp->get_section('description','')->subst(qr'Development/Languages', 'System/Internationalization '."\\\nProvides: eclipse-i18n-\%1");
    $jpp->get_section('files','')->subst(qr'Text Editors/Integrated Development Environments \(IDE\)', 'System/Internationalization '."\\\nProvides: eclipse-i18n-\%1");
};

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q'
# It tekes too long for osgi to complete :(
%add_findreq_skiplist /usr/share/*
%add_findprov_skiplist /usr/share/*
');


};
