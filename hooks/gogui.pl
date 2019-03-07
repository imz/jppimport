#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: /usr/bin/xsltproc docbook-style-xsl'."\n");
};

__END__
