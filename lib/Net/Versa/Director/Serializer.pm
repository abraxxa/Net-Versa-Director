package Net::Versa::Director::Serializer;

# ABSTRACT: Versa Director REST API serializer

use v5.36;
use Moo;
use Types::Standard qw(Enum);

extends 'Role::REST::Client::Serializer';

has '+type' => (
    isa => Enum[qw{application/json application/vnd.yang.data+json}],
    default => sub { 'application/json' },
);

our %modules = (
    'application/json' => {
        module => 'JSON',
    },
    'application/vnd.yang.data+json' => {
        module => 'JSON',
    },
);

has '+serializer' => (
    default => \&_set_serializer,
);

sub _set_serializer ($self) {
    return unless $modules{$self->type};

    my $module = $modules{$self->type}{module};

    return Data::Serializer::Raw->new(
            serializer => $module,
    );
}

1;