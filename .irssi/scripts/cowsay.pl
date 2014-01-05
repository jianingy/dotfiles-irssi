use IPC::Open3;
use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind active_win);
$VERSION = "1.14";
%IRSSI = (
    authors	=> 'Jianing Yang',
    contact	=> 'jianingy.yang@gmail.com',
    name	=> 'Cowsay',
    description	=> 'Safe cowsay implementation (with color support!)',
    license	=> 'Public Domain',
    url		=> '',
    changed	=> '',
    changes	=> '',
);

command_bind(
    cowsay => sub {
		my ($msg, $server, $dest) = @_;
		my @cowsay;
		my $prefix = '';
		my $pid = open3(*IN, *FIG, *FIGERR,  qw(cowsay));
		print IN "$msg\n";
		close IN;
		while (<FIG>) {
			chomp;
			push @cowsay, $_;
		}
		close FIG;
		waitpid $pid, 0;
		if ($dest->{type} eq "CHANNEL" || $dest->{type} eq "QUERY") {
			for (@cowsay) {
				$dest->command("/msg " . $dest->{name} . " $_" );
			}
		}
    }
);
