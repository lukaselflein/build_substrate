""" Create a crystalline layer of gold, export to pdb. 
Copyright 2019 Simulation Lab
University of Freiburg
Author: Lukas Elflein <elfleinl@cs.uni-freiburg.de>
"""

import ase.build
import ase.io
import pandas as pd
import csv


def build_substrate(size=(12,14,6), lattice_constant=4.075):
    """
    >>> build_substrate(size=(12,14,6), lattice_constant=4.075).cell
    array([[34.5775216 ,  0.        ,  0.        ],
           [ 0.        , 34.93584746,  0.        ],
           [ 0.        ,  0.        , 14.11621408]])
    """
    struc = ase.build.fcc111('Au', 
                             size=size,
                             a=lattice_constant,
                             periodic=True,
                             orthogonal=True)
    return struc

def old_clean_pdb(struc):
    ase.io.write('unclean.pdb', struc)
    df = pd.read_csv('unclean.pdb', sep=r'\s+', skiprows=2, skipfooter=1, 
                     header=None, engine='python')

    # Add incrementing numbers (why?)
    df[4] = df.index + 1

    # Replace 'Mol' with 'SUR' (for "surface")
    df[3] = 'SURF'
    
    df[0] += ' '

    df.to_csv('test.pdb', sep=' ', header=False, index=False, float_format='%2.3f',  quoting=csv.QUOTE_NONE, escapechar=' ')

    newfile = []
    with open('test.pdb', 'r') as infile:
        for line in infile:
            line = line.replace(' ', '  ')
            newfile += line

    with open('test.pdb', 'w') as outfile:
        outfile.write(''.join(newfile))
        outfile.write('TER       0         SUR\n')
        outfile.write('END\n')
    
def clean_pdb(struc):
    ase.io.write('unclean.pdb', struc)

    formatted_lines = []
    with open('unclean.pdb', 'r') as infile:
        # Skip first two lines
        infile.readline()
        infile.readline()
        i = 1
        for line in infile:
            line = line.replace('MOL     1', 'SURF {:4d}'.format(i))
            formatted_lines += line
            i += 1

    with open('test.pdb', 'w') as outfile:
        outfile.write(''.join(formatted_lines))


def main():
    struc = build_substrate()
    clean_pdb(struc)



if __name__ == '__main__':
    main()
