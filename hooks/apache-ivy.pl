#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('AutoReqProv: yes,noosgi'."\n");
    $spec->get_section('package','')->push_body('Obsoletes: ivy < 2'."\n");
    #-Provides: mvn(jayasoft:ivy) = 2.4.0.local.20180508174005
    #+Provides: mvn(jayasoft:ivy) = 2.4.0.local.20180508173955
    #error (#100): non-identical noarch packages
    $spec->get_section('prep')->push_body('
# girar noarch diff
sed -i -e s,yyyyMMddHHmmss,yyyyMMddHH, build.xml
'."\n");
};

__END__
