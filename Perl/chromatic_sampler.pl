#! usr/bin/perl

use Math::Random;

$file = "../ChromeProbsFeb4.csv";

open(IN,"<$file") or die ("Couldn't open input file\n");
@alldata = <IN>;
close(IN);

%stats; %oldcolors; %newcolors;
$count = 0;
for($i=2;$i<@alldata;$i++){ # skip first two header lines
	@line = split(",",$alldata[$i]);
	for($j=0;$j<@line;$j++){
		if($line[$j] eq ""){ $line[$j] = 0; } # Replace with zeros
	}
	$sumold = $line[3]+$line[4]+$line[5]; $sumnew = $line[6]+$line[7]+$line[8];
	if($sumold > 0 and $sumold == $sumnew){ 
		@{$stats{$count}} = splice(@line,0,3);
		@{$oldcolors{$count}} = splice(@line,3,3);
		@{$newcolors{$count}} = splice(@line,6,3);
		$count++;
	}
}

undef($i); undef($j); undef(@line); undef(@alldata); undef($count);

$t = 10000;
$burnin = 1000;

$xmin = 0; $xmax = 100;

@keys = keys %stats;

@x;
$newx = rand($xmax);
$x[0] = $newx;

for($i=0;$i<@keys;$i++){
	$newx = random_normal(1,$x[$i-1],1);
	if($newx<$xmin){$newx = $xmin;}elsif($newx>$xmax){$newx = $xmax;}

	
}


