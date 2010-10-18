package SimpleTemplate::Add;

use strict;
use warnings;
use Data::Dumper;

use base qw(SimpleTemplate);

our $VERSION = 1;

##
# This module is responsible for Adding a new configuration
sub new{
    my( $class ) = shift;
    $class->SUPER::new( @_ );
}

sub update_config{
    my ( $self ) = @_;
    my $template = Template->new(
	INCLUDE_PATH => $self->{'config'}->{'template_engine'}->{'template_directory'}.'/'. $self->{'config'}->{'template_engine'}->{'service_type'},
	OUTPUT_PATH => $self->{'config'}->{'service_config'}->{'service_config_directory'},
);

    # Get file name
    my $file_name = $self->{'domain'};

    if ( $self->{'config'}->{'service_config'}->{'config_style'} =~ m/split/i ){
	# Write file
	my %vhost;
	$vhost{'vhost'} = $self->{'vhost'};
	$template->process( 'simple_template.tpl', \%vhost, 'simple_test.conf' ) || print Dumper $template->error();
    }
    else{
	# monolithic not implemented yet
    }
    $self->_post_update_processing( 'add' );
}

1;
