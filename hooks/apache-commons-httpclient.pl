require 'set_manual_no_dereference.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('Provides: jakarta-commons-httpclient = %version'."\n");
};

__END__
