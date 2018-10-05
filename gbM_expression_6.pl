#!/usr/bin/perl
use warnings;
use strict;

die "Usage: perl program <in> <out>" if (@ARGV != 6); # usage infromation
my ($s0,$s250,$s500,$list,$out,$flag) = @ARGV;

open (IN1,$s0) or die "Can not open the input:$!\n";
open (OUT,">$out") or die "Can not open the output_file:$!\n";
my $S0;
while(my $line = <IN1>){
    chomp $line;
    my @array = split /\s+/,$line;
    $S0->{$array[0]}=$array[1];
}
close IN1;

open (IN2,$s250) or die "Can not open the input:$!\n";
my $S250;
while(my $line = <IN2>){
    chomp $line;
    my @array = split /\s+/,$line;
    $S250->{$array[0]}=$array[1];
}
close IN2;

open (IN3,$s500) or die "Can not open the input:$!\n";
my $S500;
while(my $line = <IN3>){
    chomp $line;
    my @array = split /\s+/,$line;
    $S500->{$array[0]}=$array[1];
}
close IN3;
 
open (LIST,$list) or die "Can not open the input:$!\n";
while(my $line = <LIST>){
    chomp $line;
    my @array = split /\s+/,$line;
    $array[3] =~ m/.+\|(.+)/;    my $ama_gene = $1;
    $array[5] =~ m/.+\|(.+)/;    my $rap_gene = $1;
    $array[7] =~ m/.+\|(.+)/;    my $sal_gene = $1;

    my $gene = $rap_gene;
    my ($gene0, $gene250, $gene500);
    if(exists $S0->{$gene}){$gene0 = $S0->{$gene};}else{$gene0 = 0;}
    if(exists $S250->{$gene}){$gene250 = $S250->{$gene};}else{$gene250 = 0;}
    if(exists $S500->{$gene}){$gene500 = $S500->{$gene};}else{$gene500 = 0;}

    $s0 =~ m/(.+)_.+\.rpkm\.norm/;

    print OUT $flag,"\t",$1,"\t","Salt","\t",abs($gene0 - $gene250),"\n";
    print OUT $flag,"\t",$1,"\t","UV-B","\t",abs($gene0 - $gene500),"\n";

}
close LIST;
close OUT;
