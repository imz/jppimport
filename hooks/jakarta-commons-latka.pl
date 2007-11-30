#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;

    # TODO: generalize
    $jpp->get_section('package','')->push_body('BuildRequires: dos2unix'."\n");
#Ёто чистый #!/bin/sh скрипт, в котором досовские окончани€ строк \r\n.
#»менно из-за этого шелл не может его распарсить.
    $jpp->get_section('install')->push_body('find $RPM_BUILD_ROOT -name *.sh -print0 | xargs -0 dos2unix'."\n");
}
