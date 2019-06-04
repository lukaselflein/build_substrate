""" Create a crystalline layer of gold, export to pdb. 
Copyright 2019 Simulation Lab
University of Freiburg
Author: Lukas Elflein <elfleinl@cs.uni-freiburg.de>
"""

import ase.build
import ase.io
import pandas as pd


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

def clean_pdb(struc):
    ase.io.write('unclean.pdb', struc)
    df = pd.read_csv('unclean.pdb', sep=r'\s+', skiprows=2, skipfooter=1, 
                     header=None, engine='python')

    # Add incrementing numbers (why?)
    df[4] = df.index + 1

    # Replace 'Mol' with 'SUR' (for "surface")
    df[3] = 'SURF'

    df.to_csv('tidy.csv', sep='\t', header=False, index=False, float_format='%.3f')

    with open('tidy.csv', 'a') as infile:
        infile.write('TER\t{}\t \tSUR\t{}\n'.format(len(df), len(df)+1))
        infile.write('END')
    

def main():
    struc = build_substrate()
    clean_pdb(struc)



if __name__ == '__main__':
    main()
