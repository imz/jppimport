#!/usr/bin/perl -w

require 'set_jetty6_servlet_25_api.pl';

# TODO: enable patch9 for plexus-archiver-a8+ 

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $jpp->add_patch('xfire-1.2.6-alt-xfire-annotations-add-qdox-dep.patch',STRIP=>1);

#    $jpp->get_section('package','')->subst_if(qr'classpathx-mail-monolithic','classpathx-mail', qr'Requires:');
    $jpp->get_section('package','')->subst_if(qr'jaxws_2_0_api','jaxws_2_1_api', qr'Requires:');
    $jpp->get_section('package','')->unshift_body(q'BuildRequires: saxon8 axis2-jaxws-2.0-api'."\n");

# xfire-xmpp doesn't build with smack 3
    $jpp->get_section('package','')->subst_if(qr'smack','smack1', qr'BuildRequires:');
    $jpp->get_section('package','xmpp')->subst_if(qr'smack','smack1', qr'Requires:');
# TODO: depmap changed by hand :( stack -> stack1, stackx -> stack1x

#        3) commons-primitives:commons-primitives:jar:1.0
#1 required artifact is missing.
    $jpp->get_section('package','')->unshift_body(q'BuildRequires: jakarta-commons-primitives'."\n");

    $jpp->get_section('build')->subst(qr'build-classpath bouncycastle/bcprov','build-classpath bcprov');

#      mvn install:install-file -DgroupId=net.sf.saxon -DartifactId=saxon \
#          -Dversion=8.7 -Dpackaging=jar -Dfile=/path/to/file
# see below

}
__END__
unshift_body2_after
qr'export DEPMAP'
547a548,556
> mvn-jpp -e \
>         -s $SETTINGS \
>         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
>         -Dmaven.test.failure.ignore=true \
>         -Dmaven2.jpp.depmap.file=$DEPMAP \
>         -Djava.awt.headless=true \
>       install:install-file -DgroupId=net.sf.saxon -DartifactId=saxon \
>       -Dversion=8.7 -Dpackaging=jar -Dfile=$(build-classpath saxon8)
> mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5  -e \
>         -s $SETTINGS \
>         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
>         -Dmaven.test.failure.ignore=true \
>         -Dmaven2.jpp.depmap.file=$DEPMAP \
>         -Djava.awt.headless=true \
>       install:install-file -DgroupId=com.bea.xml -DartifactId=jsr173-ri -Dversion=1.0 -Dpackaging=jar -Dfile=/usr/share/java/bea-stax-ri.jar
> 
> mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5  -e \
>         -s $SETTINGS \
>         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
>         -Dmaven.test.failure.ignore=true \
>         -Dmaven2.jpp.depmap.file=$DEPMAP \
>         -Djava.awt.headless=true \
>       install:install-file -DgroupId=org.codehaus.xfire -DartifactId=bcprov-jdk15 -Dversion=133 -Dpackaging=jar -Dfile=/usr/share/java/bcprov.jar
>

With a keen eye for details, one truth will prevail!

"Case Closed. First New Century.

It was the first new century
In one hundred years
And when I felt like I should cry
I laughed away my tears

The end of a millenium
We waited a long long time
To see the brave new world
And the mountains we would climb

The things I try to comprehend
As a child remained a mystery
There's nothing I need to defend
There's nothing great about me

All that I'll ever believe
Is the pounding of my heart
No it doesn't answer questions
That's just the way it goes

All I will ever have faith in
Is the beating in my chest
It won't predict tommorow
Or give me eternal rest
".


"Step by Step

It's just my imagination
A sort of empty concentration
While I fiddle with my fingers
And take a sip of lukewarm tea
Let's walk lightly to the
Infectious rhythm of the cool bossa-nova
And myriad puzzle pieces are here for me

That's right
I was in the same place just last week
And I ought to know
The only things changed are my clothes

Step by step
You're in control, don't be uptight
Case by case
Go ahead and laugh, everything's alright
Beyond the countless days and endless nights
I know she patiently waits just for me, but
I gotta go my own way
".


"Charge of the Light Brigade

 Half a league, half a league,
     Half a league onward,
 All in the valley of Death
     Rode the six hundred.
 `Forward, the Light Brigade!
 Charge for the guns!' he said:
 Into the valley of Death
     Rode the six hundred.

 `Forward, the Light Brigade!'
Was there a man dismay'd?
Not tho' the soldier knew
    Some one had blunder'd:
Theirs not to make reply,
Theirs not to reason why,
Theirs but to do and die:
Into the valley of Death
    Rode the six hundred.

Cannon to right of them,
Cannon to left of them,
Cannon in front of them
    Volley'd and thunder'd;
Storm'd at with shot and shell,
Boldly they rode and well,
Into the jaws of Death,
Into the mouth of Hell
    Rode the six hundred.

Flash'd all their sabres bare,
Flash'd as they turn'd in air
Sabring the gunners there,
Charging an army, while
    All the world wonder'd:
Plunged in the battery-smoke
Right thro' the line they broke;
Cossack and Russian
Reel'd from the sabre-stroke
    Shatter'd and sunder'd.
Then they rode back, but not
    Not the six hundred.

Cannon to right of them,
Cannon to left of them,
Cannon behind them
    Volley'd and thunder'd;
Storm'd at with shot and shell,
While horse and hero fell,
They that had fought so well
Came thro' the jaws of Death,
Back from the mouth of Hell,
All that was left of them,
    Left of six hundred.

When can their glory fade?
O the wild charge they made!
    All the world wonder'd.
Honour the charge they made!
Honour the Light Brigade,
    Noble six hundred!

      -- Alfred, Lord Tennyson
".
