#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'add_missingok_config.pl';
# jsp-2.1 fails on JDK 1.6, but eclipse requires JDK 1.6 :(
#require 'set_target_15.pl';

#TODO as a hook
#require 'set_maven_test_skip.pl';
#subst 's,mvn-jpp ,mvn-jpp -Dmaven.test.skip=true ,' *.spec

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # jsp-2.1 fails on JDK 1.6, but eclipse requires JDK 1.6 :(
    # one way is to try to build glassfish-jasper with java5
    #$jpp->get_section('package','')->unshift_body('BuildRequires: java-devel = 1.5.0'."\n");
    # other way is just use ecj for java5
    $jpp->copy_to_sources('ecj-3.3.1.1.jar');
    $jpp->get_section('package','')->push_body('Source33:        ecj-3.3.1.1.jar'."\n");
    $jpp->get_section('build')->unshift_body_after('mkdir -p .m2/repository/JPP
cp %{SOURCE33} .m2/repository/JPP/ecj.jar
',qr'^ln -s \%{_javadir} external_repo/JPP');

    #%define appdir /srv/jetty6
    $jpp->get_section('package','')->subst_if(qr'/srv/jetty6', '/var/lib/jetty6',qr'\%define');

    # requires from nanocontainer-webcontainer :(
    $jpp->get_section('package','jsp-2.0')->push_body('Provides: jetty6-jsp-2.0-api = %version'."\n");


    &add_missingok_config($jpp, '/etc/default/%{name}','');
    &add_missingok_config($jpp, '/etc/default/jetty','');
}

__END__
see also http://jira.codehaus.org/browse/JETTY-827
google also [jetty glassfish jsp 2.1]
#----------------------------------------------------
Subject:	RE: [jetty-user] Jetty-6.1.14 fails to build with IBM JDK5 due to JSONTest failure	Actions...
From:	Emanuel Pordes (eman...@invera.com)
Date:	Dec 9, 2008 10:03:26 am
List:	org.codehaus.jetty.user

Hi Jan,

The following error was hiding amongst all those warnings:

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org\apach e\taglibs\standard\tag\common\sql\DataSource Wrapper.java:[73,7] org.apache.taglibs.standard.tag.common.sql.DataSourceWrapper is not abstract and does not override a bstract method isWrapperFor(java.lang.Class<?>) in java.sql.Wrapper

So at the moment it does appear that Jetty-6 can *only* build with SUN JDK5, mostly due to the jsp-2.1 dependency from Glassfish. BTW, I'm still trying to find where I can file a bug for jasper on the Glassfish bug tracker... if only they used JIRA. :-)

Regards,

Emanuel

-----Original Message----- From: Jan Bartel [mailto:ja...@webtide.com] Sent: Tuesday, December 09, 2008 12:09 PM To: us...@jetty.codehaus.org Subject: Re: [jetty-user] Jetty-6.1.14 fails to build with IBM JDK5 due to JSONTest failure

Emanuel,

Those should be warnings and should not stop the build. Have a look on the maven build trace, there should be some other problem. Maybe try mvn -X.

cheers Jan

Emanuel Pordes wrote:

Ok, so I decided to try to build it with Sun JDK 6u11 and still have no luck.

[ERROR] BUILD FAILURE [INFO]

----------------------------------------------------------------------

-- [INFO] Compilation failure

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\com \sun\appserv\ClassLoaderUtil.java:[51,15] sun.misc .URLClassPath is Sun proprietary API and may be removed in a future release

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathF actory.java:[57,45] com.sun.org.apache.xpath.internal.jaxp.XPathFactoryImpl is Sun proprietary API and may be removed in a future release

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathF actory.java:[66,38] com.sun.org.apache.xpath.internal.jaxp.XPathFactoryImpl is Sun proprietary API and may be removed in a future release

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathI mpl.java:[65,42] com.sun.org.apache.xml.internal.dtm.DTM is Sun proprietary API and may be removed in a future release

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathI mpl.java:[67,48] com.sun.org.apache.xpath.internal.objects.XObject is Sun proprietary API and may be removed in a future release

... ... ...

Does this mean that Jetty-6 only builds with SUN JDK5? If so, that's certainly a step back from the Jetty-5 that we've been using....

Emanuel

----------------------------------------------------------------------

-- *From:* Emanuel Pordes [mailto:eman...@invera.com] *Sent:* Tuesday, December 09, 2008 11:11 AM *To:* 'us...@jetty.codehaus.org' *Subject:* RE: [jetty-user] Jetty-6.1.14 fails to build with IBM JDK5 due to JSONTest failure

Hi All,

I skipped the JSONTest and then ran into the following problem:

[ERROR] BUILD FAILURE [INFO]

----------------------------------------------------------------------

-- [INFO] Compilation failure

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathI mpl.java:[65,43] package com.sun.org.apache.xml.internal.dtm does not exist

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathI mpl.java:[66,0] package com.sun.org.apache.xpath.internal does not exist

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathI mpl.java:[67,49] package com.sun.org.apache.xpath.internal.objects does not exist

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathI mpl.java:[68,45] package com.sun.org.apache.xpath.internal.res does not exist

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathI mpl.java:[69,45] package com.sun.org.apache.xalan.internal.res does not exist

D:\jetty-6.1.14\modules\jsp-2.1\target\generated-sources\main\java\org \apache\taglibs\standard\tag\common\xml\JSTLXPathI mpl.java:[103,50] package com.sun.org.apache.xpath.internal.jaxp does not exist 
