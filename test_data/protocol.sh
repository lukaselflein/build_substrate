SUBSTRATE_BASENAME=AU_111_12x7x2
SYSTEM_BASENAME=1_SDS_on_${SUBSTRATE_BASENAME}

# box in angstrom:
# 34.578 34.936 60.0

# xyz2gro ${BASENAME}.xyz 34.57752160002218 34.935847456445074 14.116214081686353

# replace atm with SURF

# mv AU_111_12x7x2.xyz.gro AU_111_12x7x2.gro

# gmx genconf -f ${BASENAME}.gro -o ${BASENAME}.pdb -nbox $X $Y $Z -norenumber

module load GROMACS GROMACS-Top VMD

cat ${BASENAME}_ase.pdb | sed 's/MOL /SURF/' > ${BASENAME}_SURF.pdb

pdb_tidy.py ${BASENAME}_SURF.pdb > ${BASENAME}_tidy.pdb
pdb_reres_by_atom.py ${BASENAME}_tidy.pdb -resid 1 > ${BASENAME}_reres.pdb

packmol < packmol.inp

pdb_packmol2gmx.sh ${SYSTEM_BASENAME}_packmol.pdb

source gmx_solvate.sh

source gmx2pdb.sh

vmd -e psfgen.tcl

charmm2lammps.pl all36_lipid_extended_stripped ${SYSTEM_BASENAME}_psfgen -border=0 -lx=34.578 -ly=34.936 -lz=60.0