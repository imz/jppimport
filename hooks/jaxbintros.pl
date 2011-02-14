push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    warn "test jbossas rebuild. see note in hook!!";
};

__END__
# manually removed from component-info (not needed?)
      <compatible version="2.1.4"/>
      <compatible version="2.1.4-brew"/>
