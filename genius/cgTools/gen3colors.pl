#!/usr/bin/perl

my @lines;

while (<STDIN>) {
	my $str = $_;
	chomp($str);
	my $hex = "0x".substr($str, 1, length($str) - 1);
	push(@lines, $hex);
}

@lines = reverse(@lines);

while (@lines) {
	
	my $oneline = "@[";
	for	($i = 0; $i < 6; $i++) {
		my $hex = pop(@lines);
		$oneline = $oneline."HEXCOLOR(".$hex."),";
	}
	$oneline = substr($oneline, 0, length($oneline) - 1);
	$oneline.="],";
	print $oneline, "\n";
}

