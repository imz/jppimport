#!/usr/bin/perl -w

push @SPECHOOKS, 
sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('BuildRequires: dos2unix'."\n");
#��� ������ #!/bin/sh ������, � ������� ��������� ��������� ����� \r\n.
#������ ��-�� ����� ���� �� ����� ��� ����������.
    $jpp->get_section('install')->push_body(q{
find $RPM_BUILD_ROOT -name *.sh -print0 | xargs -0 dos2unix
grep -r -m 1 -l -Z '^#!/bin/sh' $RPM_BUILD_ROOT%_bindir | xargs -0 dos2unix
});
}
