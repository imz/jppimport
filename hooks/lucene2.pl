require 'set_rename_package.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &rename_package ($jpp, $alt, 'lucene', 'lucene2');
};

