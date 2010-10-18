package SimpleTemplate::System::Debian;

use strict;
use warnings;

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
	    system( $a2ensite, $domain );
	}
    }
    elsif( $action eq 'remove' ){
	my $a2dissite = Cpanel::FindBin::findbin( 'a2dissite' );
	system( $a2dissite, $domain );
    }
    else{
	print "Unknown action: $action\n";
    }
}

1;
