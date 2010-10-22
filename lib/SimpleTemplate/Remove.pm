package SimpleTemplate::Remove;

use strict;
use warnings;

use base qw(SimpleTemplate);

use Cpanel::Logger;

##
# This module is responsible for Removing a configuration

sub new{
    my( $class ) = shift;
    return $class->SUPER::new( @_ );
}

sub update_config{
    my ( $self ) =  @_;

    my $vhost_file = $self->{'domain'};

    if( -f $self->{'config'}->{'service_config'}->{'service_config_directory'}.'/'. $vhost_file ){
        $self->_post_update_processing( 'remove' );
        unlink( $self->{'config'}->{'service_config'}->{'service_config_directory'}.'/'. $vhost_file );
        return 1;
    }
    else{
        Cpanel::Logger::logger(
            {
                "message" => 'VirtualHost configuration for '.$self->{'domain'}.' does not exist!',
                'level' => 'warn',
                'backtrace' => 0,
                'output' => 0,
                'service' => 'simpletemplate::remove',
            }
        );
    }
}

1;
