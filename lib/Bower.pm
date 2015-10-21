package Bower;
use 5.008001;
use strict;
use warnings;

use Moose;    # automatically turns on strict and warnings
use Path::Class;

our $VERSION = "0.01";

use Mojo::JSON qw(decode_json encode_json);
use Mojo::UserAgent;
use Data::Printer;


has 'name'             => ( is => 'rw', isa => 'Str' );
has 'version'          => ( is => 'rw', isa => 'Str' );
has 'main'             => ( is => 'rw', isa => 'Str' );
has 'description'      => ( is => 'rw', isa => 'Str' );
has 'module_type'      => ( is => 'rw', isa => 'ArrayRef[Str]' );
has 'homepage'         => ( is => 'rw', isa => 'Str' );
has 'keywords'         => ( is => 'rw', isa => 'ArrayRef[Str]' );
has 'ignore'           => ( is => 'rw', isa => 'ArrayRef[Str]' );
has 'dependencies'     => ( is => 'rw', isa => 'HashRef[]' );
has 'dev_dependencies' => ( is => 'rw', isa => 'HashRef[]' );
has 'debug'            => ( is => 'rw', isa => 'Bool', default => 1 );

=head2 parse 

    Parse the file into the current object

=cut

sub parse {

    my ( $self, $name ) = @_;

    my $filename = $name || 'bower.json';

    if ( -e $filename ) {

        my $file = file($filename);

        my $content = $file->slurp( iomode => '<:encoding(UTF-8)' );

        if ($content) {

            my $dump = decode_json $content;

            $self->name( $dump->{name} );
            $self->authors( $dump->{authors} );
            $self->description( $dump->{description} );
            $self->module_type( $dump->{module_type} || [] );
            $self->homepage( $dump->{homepage} );
            $self->keywords( $dump->{keywords}                || [] );
            $self->ignore( $dump->{ignore}                    || [] );
            $self->dependencies( $dump->{dependencies}        || [] );
            $self->dev_dependencies( $dump->{devDependencies} || [] );

        }

        return $self;

    } else {

        return;
    }

}

=head2 write

    Write the current object to the bower.json

=cut

sub write {

    my ( $self, $name ) = @_;

    # file name
    my $filename = $name || 'bower.json';

    # Default naming
    my $file = file($filename);

    # Dump the current object
    my $dump = {};

    $dump->{name}            = $self->name;
    $dump->{authors}         = $self->authors;
    $dump->{description}     = $self->description;
    $dump->{module_type}     = $self->module_type;
    $dump->{homepage}        = $self->homepage;
    $dump->{keywords}        = $self->keywords;
    $dump->{ignore}          = $self->ignore;
    $dump->{dependencies}    = $self->dependencies;
    $dump->{devDependencies} = $self->dev_dependencies;

    my $json = encode_json $dump;
    $file->spew( iomode => '>:utf8', $json );

    return;
}

=head2 init

    create a bower.json file in the current directory

=cut

sub init {

    my ( $self, $params ) = @_;

}

=head2 install 

    Install a package or if package missing every dependency

    Params
        
        save        -> save to bower.json dependencies
        save-dev    -> save to bower.json devDependencies

=cut

sub install {

    my ( $self, $package, $source, $params ) = @_;

    if ( $package && $source ) {

        # Download package

        # Unpack

        # Install into sub directory

        # Parse bower.json and install dependencies

    } else {

        # Install dependencies
        my $dependencies = $self->dependencies;

        while ( ( $package, $source ) = each %$dependencies ) {

            $self->install( $package, $source );
        }

    }
}

=head2 search 

    Search the global bower repository 

=cut

sub search {

    my ( $self, $keyword ) = @_;

    my $ua = Mojo::UserAgent->new;

    my $result;

    eval {

        $result = $ua->get( sprintf( 'https://bower.herokuapp.com/packages/search/%s', $keyword ) )->res->json;
    };

    if ($@) {

        warn $@;
        return;

    } else {

        p $result if $self->debug;

        return $result;
    }
}

=head2 remove

    Remove a package

=cut

sub remove {

    my ( $self, $package ) = @_;

}

1;
__END__

=encoding utf-8

=head1 NAME

Bower - handle js components like bower

=head1 SYNOPSIS

    use Bower;

=head1 DESCRIPTION

Bower is the perl clone of the javascript packaging tool bower

=head1 LICENSE

Copyright (C) Jens Gassmann.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Jens Gassmann E<lt>jens.gassmann@atomix.deE<gt>

=cut

