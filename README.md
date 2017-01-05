NAME

    DBIx::Class::Schema::VersionCheck - compare database version to schema
    with DBIC::DeploymentHandler

VERSION

    version 0.001

SYNOPSIS

    Load this component in your schema:

        package MyApp::Schema;
    
        use base 'DBIx::Class::Schema';
    
        __PACKAGE__->load_components('Schema::CheckVersion');

    Then in the startup code of your application call check_version():

        my $schema = MyApp::Schema->connect( ... );
        $schema->check_version();

METHODS

 check_version()

    Uses DBIx::Class::DeploymentHandler to compare database_version with
    schema_version. Dies if database is older or newer than your schema.

    Override _database_to_new or _database_to_old to change the behaviour
    in either case.

AUTHOR

    Daniel Böhmer <dboehmer@cpan.org>

COPYRIGHT AND LICENSE

    This software is copyright (c) 2017 by Daniel Böhmer.

    This is free software; you can redistribute it and/or modify it under
    the same terms as the Perl 5 programming language system itself.

