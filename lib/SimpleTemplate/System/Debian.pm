package SimpleTemplate::System::Debian;

use strict;
use warnings;

use lib '/usr/local/cpanel';
use Cpanel::FindBin;

##
# @param string action
#     Valid values: add remove

sub update_config{
    my ( $action, $domain ) = @_;
    return if !$action;
    return if !$domain;
    if( $action eq 'add' ){
	my $a2ensite = Cpanel::FindBin::findbin( 'a2ensite' );
	if( $a2ensite ){
	    # TODO Switch to Open3
	    system( $a2ensite, $domain );
	    system( '/etc/init.d/apache2', 'reload' );
	}
    }
    elsif( $action eq 'remove' ){
	my $a2dissite = Cpanel::FindBin::findbin( 'a2dissite' );
	# TODO switch to Open3
	system( $a2dissite, $domain );
	system( '/etc/init.d/apache2', 'reload' );
    }
    else{
	print "Unknown action: $action\n";
    }
}

1;
