#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('files','')->push_body('
%exclude %{_javadir}/repository.jboss.com/*
%exclude %{_javadir}/repository.jboss.com
');
};

