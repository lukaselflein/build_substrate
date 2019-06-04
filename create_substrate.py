""" Create a crystalline layer of gold, export to pdb. 
Copyright 2019 Simulation Lab
University of Freiburg
Author: Lukas Elflein <elfleinl@cs.uni-freiburg.de>
"""

import ase.build
import ase.io


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


def main():
    struc = build_substrate()
    ase.io.write('test.pdb', struc)


if __name__ == '__main__':
    main()
