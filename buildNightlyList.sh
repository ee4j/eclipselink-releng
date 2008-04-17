# !/bin/sh

export JAVA_HOME=/shared/common/ibm-java2-ppc-50
export PATH=${JAVA_HOME}/bin:/usr/bin:/usr/local/bin:${PATH}

cd /shared/technology/eclipselink

echo "generating webpage"

# safe temp directory
tmp=${TMPDIR-/tmp}
tmp=$tmp/somedir.$RANDOM.$RANDOM.$RANDOM.$$
(umask 077 && mkdir $tmp) || {
  echo "Could not create temporary directory! Exiting." 1>&2 
  exit 1
}
cat ./phphead.txt > $tmp/index.xml
find /home/data/httpd/download.eclipse.org/technology/eclipselink/nightly -name \*.zip -printf '        <p> <a href="http://www.eclipse.org/downloads/download.php?file=/technology/eclipselink/nightly/%f"> %f </a>    -----    <a href="http://www.eclipse.org/eclipselink/testing/index.php"> Test Results </a></p>\n' | sort -r >> $tmp/index.xml
cat ./phptail.txt >> $tmp/index.xml

cat ./testinghead.txt > $tmp/testing.xml
#core test results

find /home/data/httpd/download.eclipse.org/technology/eclipselink/nightly/test-results/core -name \*.html -printf '        <p> <a href="http://download.eclipse.org/technology/eclipselink/nightly/test-results/core/%f"> %f </a></p>\n' | sort -r >> $tmp/testing.xml

find /home/data/httpd/download.eclipse.org/technology/eclipselink/nightly/test-results/jpa -name \*.html -printf '        <p> <a href="http://download.eclipse.org/technology/eclipselink/nightly/test-results/jpa/%f"> %f </a></p>\n' | sort -r >> $tmp/testing.xml

find /home/data/httpd/download.eclipse.org/technology/eclipselink/nightly/test-results/moxy -name \*.html -printf '        <p> <a href="http://download.eclipse.org/technology/eclipselink/nightly/test-results/moxy/%f"> %f </a></p>\n' | sort -r >> $tmp/testing.xml

find /home/data/httpd/download.eclipse.org/technology/eclipselink/nightly/test-results/sdo -name \*.html -printf '        <p> <a href="http://download.eclipse.org/technology/eclipselink/nightly/test-results/sdo/%f"> %f </a></p>\n' | sort -r >> $tmp/testing.xml

cat ./testingtail.txt >> $tmp/testing.xml

mv -f $tmp/index.xml  /home/data/httpd/download.eclipse.org/technology/eclipselink/downloads.xml
mv -f $tmp/testing.xml  /home/data/httpd/download.eclipse.org/technology/eclipselink/testing.xml
rm -rf $tmp