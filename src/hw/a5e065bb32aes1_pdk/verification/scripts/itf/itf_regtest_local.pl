#!/usr/bin/env perl

###########################################################
# These give you extra warnings/errors. Do not remove them
###########################################################
use strict;
use warnings;

use RegTest;
use Data::Dumper;
use TestUtils::XML;
use TestUtilsSystem::Messages::Standard;
use Carp;
use SetEnv;
use Readonly;
use Switch;
use List::Util 'first';

use RegressionList;
use itf_common;

##use ITFUtil;

###########################################
##----- Setup Environment Variables -----##
###########################################
&SetEnv::setup_env();



##################################
##-----Variable Declaration-----##
##################################

# TOP Module
my $top_module               = "-top sysrp_top_tb";

# VCS Compile command
my $compile_cmd              = "+v2k -sverilog -full64 -ntb_opts uvm -timescale=1ns/1fs -debug_pp -debug_access+all";

# Compile Log
my $compile_log              = "-l compile.log";

# Simulation Log
my $simulation_log           = "-l sim.log";

# Seed range
my $seed_range               = 100000;

# Max UVM Error
my $max_error                = 100;

# Maximum transaction count  
my $trans_count              = 10;

# Pass patterns
my @pass_patterns            = ("UVM_FATAL :    0", "UVM_ERROR :    0");

# Enable Coverage
my $cov_en                   = ITF::get_option("cov_en"       , "ITF") || "0";

# Enable DUMP
my $dump_on                  = ITF::get_option("dump_on"      , "ITF") || "0";


# Random seed generation
my $seed                     = ITF::get_option("seed"         , "ITF") || "1";

# UVM Verbosity
my $uvm_verbosity            = ITF::get_option("uvm_verbosity", "ITF") || "UVM_LOW";

# Testname
my $testname                 = ITF::get_option("testname"     , "ITF") ;

# DUT option
my $dut                      = ITF::get_option('dut'          , "ITF") || "no_dut";

# RTL Debug Statements
my $rtl_dbg_stmt_on          = ITF::get_option('rtl_dbg_stmt_on',"ITF") || "0";

# User Defined Options
my $user_defined_options     = " ";

# UVM options
my $uvm_options              = " ";

# Compile options
my $compile_opts             = " ";

# Simulation options
my $sim_opts                 = ITF::get_option('sim_args', "ITF") || " ";
$sim_opts = join(" ",split(",",$sim_opts));

# Simulation command
my $simulation_cmd           = " ";

# TB Files
my $tb_flists                = " ";

##my $tcam_flists              = " ";

my $rtl_flists               = " ";

my $quartus_simlib           = " ";

# Defines
my $defines                  = " ";
my $debug_def                  = " ";
my $sysrp_debug             = ITF::get_option("sysrp_debug"   , "ITF") || "1";
my $uvm_config_debug             = ITF::get_option("uvm_config_debug", "ITF") || 0;

# Enable performance

my $perf_en                = ITF::get_option("perf_en", "ITF") || 0;

##===================== Regression List Declaration ====================##
# my $regr_cfg_filename = ITF::get_option("regr_cfg", "ITF"); 
my $regr_cfg_filename = ITF::get_option("regr_cfg", "ITF") || undef;
my $regression_list = RegressionList->new($regr_cfg_filename);

# Copy MIF to VCS directory when running simulation
my @files_read_by_tb_file = ( "pcie_ss_p0_ctrl_shadow_pf_ram_reset.mif", "pcie_ss_p0_ctrl_shadow_vf_ram_reset.mif", "pcie_ss_p0_msix_vector_ctrl.mif", "int_funct2dma_chan_pf.mif", "dma_chan2funct.mif", "int_funct2dma_chan_vf.mif", "tx_qid2pfvf_init.mif", "pf2int_funct.mif" );
ITF::set_option('files_to_be_copied_to_run_directory', 'simulation', \@files_read_by_tb_file);


####################################################################
##------------------------- SUB ROUTINES -------------------------##
####################################################################

##================== Replacing the VCS script ====================##

sub gen_script {
   my ($orig_spd_script) = @_;
   system("cat $orig_spd_script  >> ${orig_spd_script}.new");
   system("sed -i '/  \$design_files */d' ${orig_spd_script}.new");
   return "${orig_spd_script}.new";
}


##===================== Compilation stage ========================##

sub compile_variants {
  return unless $regression_list->is_defined();
  return $regression_list->get_test_groups();
}

sub update_compile {
  return unless $regression_list->is_defined();

  my $variant_name = ITF::get_subtest_option("variant_name");
  my $compile_flags = $regression_list->get_compile_flags_for_test_group($variant_name);

  foreach my $flag (@$compile_flags) {
    my ($key, $value) = ($flag =~ /--(.*)=(.*)/);
    ITF::itf_print_info("Setting $key to $value\n");
    ITF::set_option($key, "ITF", $value);
  }
}

sub compile {
   if($dump_on == 1) {
     $user_defined_options .= " -debug_access+nomemcbk+dmptf -debug_region+cell -debug_pp +vcs+vcdpluson +memcbk +vcdplusmemon"; 
   }
 
   if($sysrp_debug == 1) {
     $debug_def = " +define+PCIE_RP_DEBUG";
   }
 
   if ($cov_en == 1) {
     $user_defined_options .= " +define+FCOV_ON -ntb_opts dtm -cm assert+line+cond+tgl+branch+fsm -cm_libs yv+celldefine -cm_noconst -cm_seqnoconst -cm_tgl mda -cm_dir ./simv.vdb";
   }
 
   if ($rtl_dbg_stmt_on == 1) {
     $defines .= " +define+DBG_STMT_ON";
   }
 
   if($perf_en == 1) {
    $user_defined_options .= " +define+PERF_EN";
   }
 
 
   #
   $tb_flists               = " -f $ENV{TB_PATH}/flist/rtl_files.f ";
   $tb_flists              .= " -f $ENV{TB_PATH}/flist/svt_axi_vip.f ";
   $tb_flists              .= " -f $ENV{TB_PATH}/flist/svt_pcie_vip.f ";
   $tb_flists              .= " -f $ENV{TB_PATH}/flist/dv_files.f ";
   #$rtl_flists             .= " -F $ENV{RTL_PATH}/rtl/rtl_top.f";
 
   ##$quartus_simlib         .= " -v $ENV{QUARTUS_ROOTDIR}/eda/sim_lib/altera_mf.v";
  
   $compile_opts           .= " +define+SM_X4 +define+SM_RP_SIM_ENABLE +define+IP7581SERDES_UX_SIMSPEED +define+__ALTERA_STD__METASTABLE_SIM +define+SVT_PCIE_ENABLE_GEN4 +define+GEN4 +lint=DSFIF $defines $debug_def $rtl_flists $tb_flists $quartus_simlib $user_defined_options $compile_log";
 
   $compile_cmd            .= " $compile_opts";
 
   ITF::itf_print_info("REG_LOCAL_ROOT_DIR_PATH=$ENV{REG_LOCAL_ROOT_DIR_PATH}");
   ITF::set_option('USER_DEFINED_ELAB_OPTIONS', 'simulation.vcs', "$compile_cmd");
}

# Reading regression files
sub read_list {
   my $list_file = $_[0];
   my @list;

   open (REGR_FILE,"$list_file") or die ("Could not open $list_file");
   while (<REGR_FILE>) {
     if (!($_ =~ m/^\s*([#]+([\s]*[_a-zA-Z0-9]*)*)*\s*$/g)) {
       chomp ();
       push (@list,$_);
     }
   }

   return @list;
}

sub sequence_variants {
   my @variants;
   my @my_cmd;
   my $i=0;

   # my $testname = ITF::get_option("testname" , "ITF") || "undefined_testname";

   if(defined ($testname)) {
     print("TEST NAME DEFINED : $testname \n");
     push(@variants,"$testname");

   } else {
      # if    ($regr_cfg_filename eq "sanity_regr") { @my_cmd = &read_list("sanity_regr"); }
      # else                           { @my_cmd = &read_list($regr_cfg_filename); }

      print("Using regression test list : $regr_cfg_filename \n");

      @my_cmd = &read_list($regr_cfg_filename);

      foreach my $n (@my_cmd) { 
         $i = $i + 1;  

         if($n =~ /testname=([_a-zA-Z0-9]*)/) {
              $testname= $1;
              print("testname: $testname\n");
              push(@variants,"${testname}");
         }

      }
   }

  print("variants array: @variants\n");

  print("sequence_variants stage testname: $testname\n");

  return \@variants;
}

sub update_sequence {
   my @my_cmd;
   my $count_line=0;
   my $variant_line;
   my $test_opt_val;

   my $variant      = ITF::get_subtest_option("variant_name");
   ITF::itf_print_info("Update variant: $variant");

    if(defined ($regr_cfg_filename)) {
      #my @spl = split('_', $variant);
	  #
      #foreach my $loop(@spl)
      #{
      #   $variant_line = $loop;
      #   last;
      #}

      # print("variant_line = $variant_line");

      # if    ($regr_cfg_filename eq "sanity_regr") { @my_cmd = &read_list("sanity_regr"); }
      # else                           { @my_cmd = &read_list($regr_cfg_filename); } 

      #      @my_cmd = &read_list($regr_cfg_filename);

      #foreach my $line(@my_cmd)
      #{
      #   # $count_line = $count_line + 1;

      #   # if($count_line == $variant_line){
      #      print("The command line extracted is: $line\n");

      #      # my @extract_test = split('-', $line);

      #      if($line =~ /testname=([_a-zA-Z0-9]*)/) {
      #        $testname= $1;
      #        print("extracted testname: $testname\n");
      #      }

      #      if($line =~ /seed=(\d+)/) {
      #        $seed = $1;
      #        print("extracted seed: $seed\n");
      #      } else {
              $seed = int(rand($seed_range));
      #      }

      #   # }
      }

      #ITF::set_option("testname"         , "ITF" , $testname);
      ITF::set_option("testname"         , "ITF" , $variant);
      ITF::set_option("seed"             , "ITF" , $seed);
      #}

   print("SEQUENCE UPDATE SUB: $variant $testname $seed\n");
}
sub sequence_post_process {
  my $seed = ITF::get_option("seed", "ITF");
  my $num_seeds = ITF::get_option("num_seeds", "ITF") || 1;

  #if ($regression_list->is_defined()) {
  #  my $test_group = ITFUtil::get_variant_matching_subtest_name("rtl_sim_compile_only_vcs");
  #  print "TEST IS: $test_group\n";
  #  print Dumper($regression_list->{'yaml_cfg'}->{$test_group});
  #  print $regression_list->{'yaml_cfg'}->{$test_group}->{'num_seeds'};
  #  if (defined $test_group && exists $regression_list->{'yaml_cfg'}->{$test_group}->{'num_seeds'}) {
  #    $num_seeds = $regression_list->{'yaml_cfg'}->{$test_group}->{'num_seeds'};
  #  } else {
  #    ITF::itf_print_info("Defaulting to default num_seed option!");
  #  }
  #}
  
  my $use_fixed_seed = ITF::get_option("fixed_seed", "ITF") || undef;

  if ( defined($seed)) {
	  my @seeds = ($seed);
	  ITF::set_option('run_seed_sweep__rtl_sim_simulate_only_vcs', 'ITF', \@seeds);
	  ITF::enable_seed_sweep({'seed_type'=> 'user', 'stage' => 'rtl_sim_simulate_only_vcs'});
  } else {
    if (defined($use_fixed_seed)) {
	    ITF::enable_seed_sweep({'seed' => $num_seeds, 'stage' => 'rtl_sim_simulate_only_vcs', 'seed_type' => 'fixed'});
    } else {
      my @seeds;
      for (1 .. $num_seeds) {
        my $new_seed = int(rand($seed_range));
        while (grep( /^$new_seed$/, @seeds )) {
          $new_seed = int(rand($seed_range));
        }
        push(@seeds, $new_seed);
      }
	    ITF::set_option('run_seed_sweep__rtl_sim_simulate_only_vcs', 'ITF', \@seeds);
	    ITF::enable_seed_sweep({'seed_type'=> 'user', 'stage' => 'rtl_sim_simulate_only_vcs'});
    }
  }

  # dump the command that was run
  my $variant_name = ITF::get_subtest_option("variant_name");
  if (!defined($variant_name)) {
    return;
  }

  if (!$regression_list->is_defined()) {
    return;
  }

  # my $test_group = ITFUtil::get_variant_matching_subtest_name("rtl_sim_compile_only_vcs");
  # my $test_config = $regression_list->get_config_for_test($test_group, $variant_name);
  #print Dumper($test_config);
  #
  #my $options = $test_config->{'options'};
  #my $testname = $test_config->{'uvm_testname'};
  #
  #my $options_as_str = join(' ', @$options);
  #
  #ITF::itf_print_info("Writing to file regression_cmd_report.txt");
  #
  #open(SEQ_CMD_RUN_FH, '>', 'regression_cmd_report.txt');
  #print SEQ_CMD_RUN_FH "--testname=$testname $options_as_str";
  #close(SEQ_CMD_RUN_FH);

}

##====================== Simulation stage ========================##
sub simulate {
  
  my $variant_name = ITF::get_subtest_option("variant_name");

  if(!defined ($regr_cfg_filename)) {
  my $testname = ITF::get_option("testname", "ITF");
  }

  # my $seed = ITF::get_option("seed", "ITF");
  if (!defined($seed)) {
    if ($variant_name =~ /s[0-9]+/) {
      $variant_name =~ s/s//g;
      $seed = $variant_name;
    } else {
      $seed = int(rand($seed_range));
    }
    ITF::set_option("seed", "ITF", $seed);
  }

  ITF::itf_print_info("Simulate Stage - Seed is: $seed");

  my $plusargs               = ITF::get_option("plusargs", "ITF");
  $plusargs = "+".$plusargs;
  $plusargs = join(" +", split(',',$plusargs));


   $uvm_options            .= " +UVM_VERBOSITY=$uvm_verbosity +ntb_random_seed=$seed +UVM_TESTNAME=$testname -cm_name ${testname}_${seed} +UVM_MAX_QUIT_COUNT=$max_error  $plusargs";

   #$sim_opts               .= " +trans_count=$trans_count +ETH_INTERFACE_SELECT=136 +ETH_FIRST_CASE=1 +ETH_LAST_CASE=1 +ETH_BASIC_TEST";

  if ($cov_en == 1) {
     $user_defined_options .= " -ntb_opts dtm -cm assert+line+cond+tgl+branch+fsm -cm_dir ./simv.vdb";
  }

   $user_defined_options   .= " +licq $uvm_options $sim_opts";

   $simulation_cmd         .= " $user_defined_options $simulation_log";
 
   ITF::itf_print_info("Simulate Stage - Testname=$testname");

   ITF::set_option('USER_DEFINED_SIM_OPTIONS', 'simulation.vcs', "$simulation_cmd");
}


####################################################################
##------------------------- ITF Options --------------------------##
####################################################################
# Required
ITF::set_option('run_spd_flow' , 'simulation', 1);

ITF::set_option('no_testbench_source_files' , 'simulation.vcs' , 1);

# Since there are no IP files generated
ITF::set_option('no_generated_ip_files', 'simulation', 1);

# Top Level module
ITF::set_option('testbench_name' , 'simulation' , "sysrp_top_tb");

ITF::set_option('custom_gen_spd_sim_script_fn', 'simulation.vcs', \&gen_script );

# For setting the pass signature in simulation
ITF::set_option('sim_log_passing_patterns_arr_ref' , 'simulation', \@pass_patterns);
ITF::set_option('use_all_passing_patterns'         , 'simulation', 1);



####################################################################
##------------------------- ITF Function Calls -------------------##
####################################################################

#ITF::register_function("vcs_compile_only_resources" ,"get_arc_resources", \&vcs_compile_only_resources);

# Configure test based on compile variants
#ITF::register_function("rtl_sim_compile_only_vcs", "get_variant_list", \&compile_variants);
#ITF::register_function("rtl_sim_compile_only_vcs", "update_variant", \&update_compile);

# Pre-Compilation Stage
ITF::register_function("rtl_sim_compile_only_vcs", "run_pre_process", \&compile);

# Configure test based on testname + sim_opts
ITF::register_function("sequence", "get_variant_list" , \&sequence_variants);
ITF::register_function("sequence", "update_variant" , \&update_sequence);

# Post-Sequencing Seed configuraton and data dump
ITF::register_function("sequence", "run_post_process", \&sequence_post_process);

# Pre-Simulation Stage
ITF::register_function("rtl_sim_simulate_only_vcs", 'run_pre_process', \&simulate);


# do not remove the line below!
1;
