package SimpleTemplate::AddonDomain;

use strict;
use warnings;

our $VERSION = 1;

use lib '/usr/local/cpanel';

use Cpanel::Config::userdata::Load;

##
# Facilitates multi-domain hosting. i.e. Addon domains are handled as actual domains, rather than a domain parked on the primary domain
#
#

sub get_actual_domain{
    my ( $user, $sub_domain ) = @_;

    my $domain_listing = Cpanel::Config::userdata::Load::load_userdata( $user, 'main' );
    if( exists $domain_listing->{'addon_domains'} ){
	my %addons = %{ $domain_list->{'addon_domains'} };
	my %reversed_addons = reverse %addons;
	if( exists $reversed_addons{ $sub_domain } ){
	    return $reversed_addons{ $sub_domain };
	}
    }
}

1;
