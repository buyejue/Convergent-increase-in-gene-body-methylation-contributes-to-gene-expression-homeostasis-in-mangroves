#!usr/bin/perl
use warnings;
use strict;

die "Usage: perl program <input> <temp_seq> <temp_mus> <output>",if (@ARGV != 3); # usage infromation
my($cds,$list,$out) = @ARGV;

open IN,$cds or die "ERROR in IN: $!\n";
open (OUT,">$out") or die "Can not open the output_file:$!\n";
my $db;
my ($id,$seq);
while(my $line = <IN>){
    chomp $line;
	if($line =~ m/^>(\S+)/){
		$id = $1;
	}
	else{
	    $seq = $line;
	}
	$db->{$id}=$seq;
}
close IN;

open IN2,$list or die "ERROR in IN: $!\n";
open (OUT,">$out") or die "Can not open the output_file:$!\n";

while(my $line = <IN2>){
	chomp $line;
	my @array = split /\s+/,$line;
	$array[2] =~ s/\.p//;
	$array[6] =~ s/\.p//;
	my @Mgu_OE = &cal_oe($db->{$array[2]});
	my @Ptr_OE = &cal_oe($db->{$array[4]});
	my @Egr_OE = &cal_oe($db->{$array[6]});

	my @Ama_OE = &cal_oe($db->{$array[3]});
	my @Rap_OE = &cal_oe($db->{$array[5]});
	my @Sal_OE = &cal_oe($db->{$array[7]});

	$list =~ m/.+\.(.+)/;
	#print OUT $1,"\t","Ama","\t",$Ama_OE,"\n",
	#		  $1,"\t","Rap","\t",$Rap_OE,"\n",
	#		  $1,"\t","Sal","\t",$Sal_OE,"\n";
	print OUT $array[0],"\t",$1,"\t","Mgu","\t",@Mgu_OE,"\n",
			  $array[0],"\t",$1,"\t","Ptr","\t",@Ptr_OE,"\n",
			  $array[0],"\t",$1,"\t","Egr","\t",@Egr_OE,"\n",
			  $array[0],"\t",$1,"\t","Ama","\t",@Ama_OE,"\n",
			  $array[0],"\t",$1,"\t","Rap","\t",@Rap_OE,"\n",
			  $array[0],"\t",$1,"\t","Sal","\t",@Sal_OE,"\n";
}

#========================================SUB==============================================
sub cal_oe {
	my($seq) = @_;
	my ($cg, $c, $g, $total) = (0, 0, 0);
	for my $i (0..length($seq)-1) {
		my $base = substr($seq, $i, 1);
		next if($base eq "N");
		$total++;

		if($base eq "C") {
			$c++;
		} elsif ($base eq "G") {
			$g++;
		}
	}

	for my $i (0..length($seq)-1) {
		my $base = substr($seq, $i, 2);
		next if($base =~ m/N/);
		if($base eq "CG") {
			$cg++;
		}
	}

	my $oe = ($cg/$total/2)/(($c/$total)*($g/$total))*2;
		
	#return $oe;
	return $cg/$total/2,"\t",$c/$total,"\t",$g/$total,"\t",$oe,"\t",length($seq);
}
#========================================SUB==============================================