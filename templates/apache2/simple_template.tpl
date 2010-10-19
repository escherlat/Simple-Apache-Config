NameVirtualHost [% vhost.ip %]:80
<VirtualHost [% vhost.ip %]:80>
    ServerName [% vhost.servername %]
    ServerAlias [% vhost.serveralias %]
    DocumentRoot [% vhost.documentroot %]
    ServerAdmin [% vhost.serveradmin %]
    [%- FOREACH logstyle IN vhost.customlog %]
    CustomLog [% logstyle.target %] [% logstyle.format %]
    [%- END -%]
    ErrorLog /usr/local/apache/domlogs/[% vhost.servername %]-error_log
    [% IF vhost.hascgi %]
    Options ExecCGI
    AddHandler cgi-script cgi plr
    [%- END %]
</VirtualHost>
