#!/bin/bash -x
set -e

system=1_SDS_on_AU_111_12x7x2
surfactant=SDS
water_model="tip3p"
force_field="charmm36"

cation="NA"
anion="BR"
ncation=1
nanion=0

bwidth=3.4578
bheight=3.4936
bdepth=6.0

# TODO: shift gold COM onto boundary
# bcx=$(bc <<< "scale=4;$bwidth/2.0")
# bcy=$(bc <<< "scale=4;$bheight/2.0")
# bcz=$(bc <<< "scale=4;$bdepth/2.0")

gmx pdb2gmx -f "1_${surfactant}.pdb" -o "1_${surfactant}.gro" \
    -p "1_${surfactant}.top" -i "1_${surfactant}_posre.itp" \
    -ff "${force_field}" -water "${water_model}" -v

gmx pdb2gmx -f "${system}.pdb" -o "${system}.gro" \
    -p "${system}.top" -i "${system}.posre.itp" \
    -ff "${force_field}" -water "${water_model}" -v

# Packmol centrered the system at (x,y) = (0,0) but did align
# the substrate at z = 0. GROMACS-internal, the box's origin is alway at (0,0,0)
# Thus we shift the whole system in (x,y) direction by (width/2,depth/2):
gmx editconf -f "${system}.gro" -o "${system}_boxed.gro"  \
    -box $bwidth $bheight $bdepth -noc -translate 0 0 1.4116

# For exact number of solvent molecules:
# gmx solvate -cp "${system}_boxed.gro" -cs spc216.gro \
#     -o "${system}_solvated.gro" -p "${system}.top" \
#    -scale 0.5 -maxsol $nSOL

# For certain solvent density
# scale 0.57 should correspond to standard condition ~ 1 kg / l (water)
gmx solvate -cp "${system}_boxed.gro" -cs spc216.gro \
    -o "${system}_solvated.gro" -p "${system}.top" \
    -scale 0.57