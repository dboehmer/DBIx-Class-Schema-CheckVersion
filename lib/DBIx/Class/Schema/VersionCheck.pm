package DBIx::Class::Schema::VersionCheck;

# ABSTRACT: compare database version to schema with DBIC::DeploymentHandler

use strict;
use warnings;

# VERSION

use base 'DBIx::Class::Schema';
use DBIx::Class::DeploymentHandler;

sub check_version {
    my $self = shift;

    my $dh = DBIx::Class::DeploymentHandler->new( schema => $self );

    if ( $dh->database_version < $dh->schema_version ) {
        $self->_database_too_old($dh);
    }
    elsif ( $dh->database_version > $dh->schema_version ) {
        $self->_database_too_new($dh);
    }
}

sub _database_too_new {
    my ( $self, $dh ) = @_;

    die "Database newer than schema: "
      . $dh->database_version . " > "
      . $dh->schema_version;
}

sub _database_too_old {
    my ( $self, $dh ) = @_;

    die "Database older than schema: "
      . $dh->database_version . " < "
      . $dh->schema_version;
}

1;
