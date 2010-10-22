NameVirtualHost [% vhost.ip %]:80
<VirtualHost [% vhost.ip %]:80>
    ServerName [% vhost.servername %]
    ServerAlias [% vhost.serveralias %]
    DocumentRoot [% vhost.documentroot %]
    ServerAdmin [% vhost.serveradmin %]
    CustomLog /usr/local/apache/domlogs/[% vhost.servername %] combined
    CustomLog /usr/local/apache/domlogs/[% vhost.servername %]-bytes_log "%{%s}t %I .\n%{%s}t %O ."
    ErrorLog /usr/local/apache/domlogs/[% vhost.servername %]-error_log
    [% IF vhost.hascgi %]
    Options ExecCGI
    AddHandler cgi-script cgi plr
    [%- END %]
</VirtualHost>
