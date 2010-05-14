require 'set_without_maven.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # bad line in spec
    $jpp->get_section('prep')->subst(qr'gzip -dc \%{SOURCE4} \| tar xf -','#gzip -dc %{SOURCE5} | tar xf -');
};

__END__
129c130
< gzip -dc %{SOURCE4} | tar xf -
---
> #gzip -dc %{SOURCE5} | tar xf -
