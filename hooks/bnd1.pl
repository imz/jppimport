#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->subst(qr'/usr/lib\*/eclipse/swt-gtk-3.\?.jar','/usr/lib*/eclipse/swt-gtk-3.*.jar');
};

__END__
