package SimpleTemplate::AddonDomain;

use strict;
use warnings;

our $VERSION = 1;

use Cpanel::Logger;
use Cpanel::Config::userdata::Load;

##
# Facilitates multi-domain hosting. i.e. Addon domains are handled as actual domains, rather than a domain parked on the primary domain
#
#

sub get_sub_domain{
    my ( $user, $addon_domain ) = @_;

    my $domain_listing = Cpanel::Config::userdata::Load::load_userdata( $user, 'main' );
    if( exists $domain_listing->{'addon_domains'} ){
	my %addons = %{ $domain_listing->{'addon_domains'} };
	if( exists $addons{ $addon_domain } ){
	    return $addons{ $addon_domain };
	}
    }
}

1;
