#!usr/bin/perl
use warnings;
use strict;

die "Usage: perl program <genome>" ,if (@ARGV != 9); # usage infromation
my($Osa,$Mgu,$Ama,$Ptr,$Rap,$Egr,$Sal,$list,$out) = @ARGV;

open OSA,$Osa or die "ERROR in IN`: $!\n";
my $osa;
while(my $line = <OSA>){
    chomp $line;
	my @array = split /\s+/,$line;
	if($array[3] eq "CG"){
		$osa->{$array[0]}->{$array[1]} = $array[4];
	}
	else{
		$osa->{$array[0]}->{$array[1]} = "P";
	}
}
close OSA;

open MGU,$Mgu or die "ERROR in IN`: $!\n";
my $mgu;
while(my $line = <MGU>){
    chomp $line;
	my @array = split /\s+/,$line;
	if($array[3] eq "CG"){
		$mgu->{$array[0]}->{$array[1]} = $array[4];
	}
	else{
		$mgu->{$array[0]}->{$array[1]} = "P";
	}
}
close MGU;

open AMA,$Ama or die "ERROR in IN`: $!\n";
my $ama;
while(my $line = <AMA>){
    chomp $line;
	my @array = split /\s+/,$line;
	if($array[3] eq "CG"){
		$ama->{$array[0]}->{$array[1]} = $array[4];
	}
	else{
		$ama->{$array[0]}->{$array[1]} = "P";
	}
}
close AMA;

open PTR,$Ptr or die "ERROR in IN`: $!\n";
my $ptr;
while(my $line = <PTR>){
    chomp $line;
	my @array = split /\s+/,$line;
	if($array[3] eq "CG"){
		$ptr->{$array[0]}->{$array[1]} = $array[4];
	}
	else{
		$ptr->{$array[0]}->{$array[1]} = "P";
	}
}
close PTR;

open RAP,$Rap or die "ERROR in IN`: $!\n";
my $rap;
while(my $line = <RAP>){
    chomp $line;
	my @array = split /\s+/,$line;
	if($array[3] eq "CG"){
		$rap->{$array[0]}->{$array[1]} = $array[4];
	}
	else{
		$rap->{$array[0]}->{$array[1]} = "P";
	}
}
close RAP;

open EGR,$Egr or die "ERROR in IN`: $!\n";
my $egr;
while(my $line = <EGR>){
    chomp $line;
	my @array = split /\s+/,$line;
	if($array[3] eq "CG"){
		$egr->{$array[0]}->{$array[1]} = $array[4];
	}
	else{
		$egr->{$array[0]}->{$array[1]} = "P";
	}
}
close EGR;

open SAL,$Sal or die "ERROR in IN`: $!\n";
my $sal;
while(my $line = <SAL>){
    chomp $line;
	my @array = split /\s+/,$line;
	if($array[3] eq "CG"){
		$sal->{$array[0]}->{$array[1]} = $array[4];
	}
	else{
		$sal->{$array[0]}->{$array[1]} = "P";
	}
}
close SAL;

open IN,$list or die "ERROR in IN`: $!\n";
open (OUT,">$out") or die "Can not open the output_file:$!\n";
my ($seq1,$seq2,$seq3,$seq4,$seq5,$seq6,$seq7);
while(my $line = <IN>){
    chomp $line;
    my @array = split /\s+/,$line;

    $array[1] =~ m/(.+)_([+-])_(\d+)/;
    if(exists $osa->{$1}->{$3}){$seq1 = $osa->{$1}->{$3};}
    else{$seq1 = "N";}

    $array[2] =~ m/(.+)_([+-])_(\d+)/;
    if(exists $mgu->{$1}->{$3}){$seq2 = $mgu->{$1}->{$3};}
    else{$seq2 = "N";}

    $array[3] =~ m/(.+)_([+-])_(\d+)/;
    if(exists $ama->{$1}->{$3}){$seq3 = $ama->{$1}->{$3};}
    else{$seq3 = "N";}

    $array[4] =~ m/(.+)_([+-])_(\d+)/;
    if(exists $ptr->{$1}->{$3}){$seq4 = $ptr->{$1}->{$3};}
    else{$seq4 = "N";}

    $array[5] =~ m/(.+)_([+-])_(\d+)/;
    if(exists $rap->{$1}->{$3}){$seq5 = $rap->{$1}->{$3};}
    else{$seq5 = "N";}

    $array[6] =~ m/(.+)_([+-])_(\d+)/;
    if(exists $egr->{$1}->{$3}){$seq6 = $egr->{$1}->{$3};}
    else{$seq6 = "N";}

    $array[7] =~ m/(.+)_([+-])_(\d+)/;
    if(exists $sal->{$1}->{$3}){$seq7 = $sal->{$1}->{$3};}
    else{$seq7 = "N";}

    print OUT $array[0],"\t",$seq1,"\t",$seq2,"\t",$seq3,"\t",$seq4,"\t",$seq5,"\t",$seq6,"\t",$seq7,"\n";
}

close IN;
close OUT;