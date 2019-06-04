# execute with
# module load vmd/1.9.3-text
# vmd -e psfgen.tcl

package require psfgen
topology top_all36_lipid_extended_stripped.rtf
# SDS residue descrition from ...detergent.str has been added to the .rtf file
# CTAB residue descrition has been constructed from LPPC head and DSPE hydro-
# carbon chain. Horinek 2009 BR parametrization and TIP3P water included.
# Atom type entries with MASS keywords have been numbered consecutively.

# map gromacs residue and atom names names to sepcific CHARMM36 names:
pdbalias residue SOL TIP3
pdbalias residue NA SOD
pdbalias residue SURF AUM

pdbalias atom TIP3 OW OH2
pdbalias atom TIP3 HW1 H1
pdbalias atom TIP3 HW2 H2
pdbalias atom SOD NA SOD
pdbalias atom SURF Au AU

segment AAAA { pdb 1_SDS_on_AU_111_12x7x2_substrate_000.pdb }
coordpdb 1_SDS_on_AU_111_12x7x2_substrate_000.pdb AAAA

segment AAAB { pdb 1_SDS_on_AU_111_12x7x2_solvent_000.pdb }
coordpdb 1_SDS_on_AU_111_12x7x2_solvent_000.pdb AAAB

segment AAAC { pdb 1_SDS_on_AU_111_12x7x2_surfactant_000.pdb }
coordpdb 1_SDS_on_AU_111_12x7x2_surfactant_000.pdb AAAC

segment AAAD { pdb 1_SDS_on_AU_111_12x7x2_ions_000.pdb }
coordpdb 1_SDS_on_AU_111_12x7x2_ions_000.pdb AAAD

# guesscoord

regenerate angles dihedrals
# Purpose: Remove all angles and/or dihedrals and completely regenerate them 
# using the segment automatic generation algorithms. This is only needed if 
# patches were applied that do not correct angles and bonds. Segment and file 
# defaults are ignored, and angles/dihedrals for the entire molecule are 
# regenerated from scratch.
# Arguments: angles: Enable generation of angles from bonds.
#            dihedrals: Enable generation of dihedrals from angles.
# Context: After one or more segments have been built.

writepdb 1_SDS_on_AU_111_12x7x2_psfgen.pdb
writepsf 1_SDS_on_AU_111_12x7x2_psfgen.psf
exit