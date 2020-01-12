import math
import numpy as np

np.set_printoptions(precision=3)

def g(mu,sigma):
    return lambda x,y: 1.0/(2*math.pi*sigma**2)*math.exp(-(x**2+y**2)/(2*sigma**2))

def weight_ball(radius):
    R=radius
    sigma=1.0/math.sqrt(2*math.pi)
    R_step=sigma/(R/2.5)

    myg=g(1,sigma)

    lx=range(0,radius+1)
    ly=range(0,radius+1)
    weight_matrix = np.zeros( (radius+1,radius+1) )

    for x in lx:
        for y in ly:
            weight_matrix[x][y] = myg(x*R_step,y*R_step)

    return weight_matrix

print(weight_ball(6))