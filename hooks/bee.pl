#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body(q!sed -i -e s,"http://7bee.j2ee.us/xml/DTD/bee.dtd,"`pwd`/deploy/doc/bee.dtd,g `find . -name '*.xml'`!."\n");
};

__END__
