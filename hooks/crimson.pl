require 'set_rename_package.pl';
# NOTE: jvm4

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &rename_package ($jpp, $alt, 'crimson', 'jakarta-crimson');
};

