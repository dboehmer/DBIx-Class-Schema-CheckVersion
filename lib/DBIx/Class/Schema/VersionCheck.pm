package DBIx::Class::Schema::VersionCheck;

# ABSTRACT: compare database version to schema with DBIC::DeploymentHandler

use strict;
use warnings;

# VERSION

use base 'DBIx::Class::Schema';
use DBIx::Class::DeploymentHandler;

sub check_version {
    my $self = shift;

    if ( $ENV{DBIC_SKIP_VERSION_CHECK} ) {
        warn "Skipping DBIC schema version check";
        return;
    }

    my $dh = DBIx::Class::DeploymentHandler->new( schema => $self );

    if ( $dh->database_version < $dh->schema_version ) {
        $self->_database_too_old($dh);
    }
    elsif ( $dh->database_version > $dh->schema_version ) {
        $self->_database_too_new($dh);
    }
    else {
        $self->_database_up_to_date($dh);
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

# do nothing by default but allow overriding
sub _database_up_to_date { }

1;

__END__

=pod

=head1 SYNOPSIS

Load this component in your schema:

    package MyApp::Schema;

    use base 'DBIx::Class::Schema';

    __PACKAGE__->load_components('Schema::CheckVersion');

Then in the startup code of your application call C<check_version()>:

    my $schema = MyApp::Schema->connect( ... );
    $schema->check_version();

=head1 METHODS

=head2 check_version()

Uses L<DBIx::Class::DeploymentHandler> to compare C<database_version>
with C<schema_version>. Dies if database is older or newer than your schema.

Override C<_database_too_new> or C<_database_too_old> to change the
behaviour in either case.

If database matches schema version nothing is done or printed by default
but you can override C<_database_up_to_date> to take action in this case.

Set environment variable C<DBIC_SKIP_VERSION_CHECK> to a true value to
completely skip the check. That's convient to use on the command line
and also avoids errors if the L<DBIx::Class::DeploymentHandler> meta
table is missing in the database.
