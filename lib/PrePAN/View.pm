package PrePAN::View;
use strict;
use warnings;

use PrePAN::Util;
use PrePAN::Config;
use Tiffany;
use Template::Stash::ForceUTF8;
use Template::Provider::Encoding;

sub new {
    my ($class) = @_;

    my $view_conf = PrePAN::Config->param('view') || {};
    if (!exists $view_conf->{path}) {
        $view_conf->{path} = root->subdir('views');
    }

    my $include_path = root->subdir('views')->stringify;
    my $view = Tiffany->load(TT => {
        INCLUDE_PATH   => [ $include_path ],
        PRE_PROCESS    => [qw(macro.tt)],
        STASH          => Template::Stash::ForceUTF8->new,
        LOAD_TEMPLATES => [
            Template::Provider::Encoding->new(
                INCLUDE_PATH => $include_path,
            ),
        ],
        FILTERS        => {
            trim_html  => [
                sub {
                    my ($context, $length, $rest) = @_;
                    return sub {
                        my $string = shift;
                        trim_html($string, $length, $rest || '...');
                    }
                },
                1,
            ],
        },

        %$view_conf
    });
}

1;
