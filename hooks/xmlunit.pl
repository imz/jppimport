#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
};

__END__
    $spec->get_section('package','')->unshift_body('BuildRequires: docbook-simple'."\n");
    # does not work, let's disable the manual
    $spec->get_section('prep')->push_body(q!# damn the net
# TODO: why catalog does not work? it is ant xslt task
sed -i 's,http://docbook.org/xml/simple/1.1b1/sdocbook.dtd,http://www.oasis-open.org/docbook/xml/simple/1.1/sdocbook.dtd,g' `grep -rl 'http://docbook.org/xml/simple/1.1b1/sdocbook.dtd' .`
!."\n");
    $spec->get_section('package','')->subst_body('bcond_without manual','bcond_with manual');
