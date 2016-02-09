require 'set_manual_no_dereference.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('Provides: jakarta-commons-httpclient = 1:%version'."\n");
};

__END__
