# pretty XML formating
xmllint --format era-platform.xml

# use Trang to reverse engineer XSD from XML
wget http://www.thaiopensource.com/download/trang-20030619.zip
unzip trang-20030619

# edit .profile
alias xml2xsd='java -jar ../trang-20030619/trang.jar'

xml2xsd era-platform.xml

# use xsdvi to visualize XML schema
http://xsdvi.sourceforge.net/

# install eXist XML DB
http://exist-db.org

