package SimpleTemplate::Remove;

use strict;
use warnings;

##
# This module is responsible for Removing a configuration

sub new{
    my( $class ) = shift;
    $class->SUPER::new( @_ );
}

sub update_config{
    my ( $self ) =  @_;
    if( -f $self->{'config'}->{'service_config'}->{'service_config_directory'}.'/'. $self->{'domain'} ){
	$self->_post_update_processing( 'remove' );
	unlink( $self->{'config'}->{'service_config'}->{'service_config_directory'}.'/'. $self->{'domain'} );
    }
}

1;
