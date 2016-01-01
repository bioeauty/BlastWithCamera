e strict;
use warnings;
use Bio::Tools::Run::RemoteBlast;
my $prog='blastn';
my $db='nt';
my $e_value='1e-10';
my $factory = Bio::Tools::Run::RemoteBlast->new('-prog' => $prog,'-data' => $db,'-expect' => $e_value,'-readmethod' => 'SearchIO' );
my $v = 1;
my $str = Bio::SeqIO->new(-file=>$ARGV[0] , -format => 'fasta' );
while (my $input = $str->next_seq())
{
my $r = $factory->submit_blast($input);
print STDERR "waiting..." if( $v > 0 );
    while ( my @rids = $factory->each_rid )        
{
    foreach my $rid ( @rids ) 
  {
    my $rc = $factory->retrieve_blast($rid);
     if( !ref($rc) ) 
   {
              if( $rc < 0 ) 
      {
                $factory->remove_rid($rid);
       }
              print STDERR "." if ( $v > 0 );
              sleep 5;
            } else 
   {
              my $result = $rc->next_result();
              
              my $filename = $result->query_name()."\.out";
              $factory->save_output($filename);
              $factory->remove_rid($rid);
              while ( my $hit = $result->next_hit )
   {
                next unless ( $v > 0);
                print "", $hit->name, "\t";
                while( my $hsp = $hit->next_hsp ) 
    {           
                  print "", $hsp->score, "\n";
                   
                }
              }
            }
          }
        }
}

