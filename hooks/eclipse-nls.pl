#!/usr/bin/perl -w

push @PREHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('BuildArch: noarch'."\n");
    # macros body
    $spec->get_section('files','')->subst_body(qr'Text Editors/Integrated Development Environments \(IDE\)', 'System/Internationalization '."\\\nProvides: eclipse-i18n-\%1");
};

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body(q'
# It takes too long for osgi to complete :(
%add_findreq_skiplist /usr/share/*
%add_findprov_skiplist /usr/share/*
');


};
