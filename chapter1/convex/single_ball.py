import os
PROJECT_FOLDER=os.path.dirname(os.path.realpath(__file__))

from chanvese.chanvese import chanvese
import numpy as np
from skimage.io import imread
from scipy.signal import convolve
import matplotlib.pyplot as plt

INPUT_FOLDER="{}/input".format(PROJECT_FOLDER)
OUTPUT_FOLDER="{}/output/single-ball".format(PROJECT_FOLDER)
ITERATIONS=100

os.makedirs(OUTPUT_FOLDER,exist_ok=True)

NEIGH=np.array( [ [0,-1,0],[-1,4,-1],[0,-1,0] ] )
def compute_energy_value(I,seg,phi,lbda):
   H=np.ones(seg.shape)
   H[phi<=0]=0
   perimeter = np.sum( np.abs( convolve(H,NEIGH) ) ) 
    
   region = np.sum( (H-I)**2 )

   return 1.0/lbda*perimeter + region
 

def execute_chanvese(lbda,input_filepath):
   img = imread(input_filepath,as_gray=True)
   m = img.copy()
   seg,phi,its=chanvese(img, m, max_its=ITERATIONS, display=False, alpha=1.0/lbda)
   ev=compute_energy_value(img,seg,phi,lbda)

   return seg,img,phi,ev

def save_fig(img,phi,output_filepath,onlycontour=True):
   fig,axe = plt.subplots(1,1)
   axe.cla()

   plt.subplots_adjust(top = 1, bottom = 0, right = 1, left = 0, 
	    hspace = 0, wspace = 0)
   plt.margins(0,0)
   plt.gca().xaxis.set_major_locator(plt.NullLocator())
   plt.gca().yaxis.set_major_locator(plt.NullLocator())
   axe.set_ylim( img.shape[0] )
   axe.set_xlim( img.shape[1] )
   axe.set_aspect("equal")
   if not onlycontour:
      plt.imshow(img, cmap='gray')
   plt.contour(phi, 0, colors="#00ff00")
   axe.set_axis_off()
   plt.savefig(output_filepath,bbox_inches = 'tight',pad_inches = 0)


def no_ball(lbda):
   img = imread("{}/ball_small.png".format(INPUT_FOLDER),asgray=True)
   phi = np.ones( (img.shape[0],img.shape[1]) )
   phi*=-1

   return phi

def the_ball(lbda):
   img = imread("{}/ball_small.png".format(INPUT_FOLDER),asgray=True)
   img_c1 = img[:,:,0]
   phi = np.zeros( img_c1.shape )
   phi[img_c1>0] = 1

   return phi

def main():
   input_filepaths=["ball_small.png"]
   lbda_list=[1.0/40.0,1.0/30.0,1.0/20.0,1.0/10.0,1.0/5.0]

   with open("{}/report.txt".format(OUTPUT_FOLDER),"w") as f:
      for filepath in input_filepaths:
         for lbda in lbda_list:
            seg,img,phi,ev = execute_chanvese(lbda,"{}/{}".format(INPUT_FOLDER,filepath))
            save_fig(img,phi,"{}/out_lbda_{}_{}".format(OUTPUT_FOLDER,lbda,filepath),False) 
            f.write("{} lbda= {} value={}\n".format(filepath,lbda,ev))

def myfunc(r,lbda,R):
   return 1.0/lbda*2*np.pi*r + np.pi*np.abs(R**2-r**2)

def results_table():
   R=36
   r_list=[0,R]
   lbda_list=[1.0/40.0,1.0/30.0,1.0/20.0,1.0/10.0,1.0/5.0]
 
   with open("{}/table-values.txt".format(OUTPUT_FOLDER),"w") as f:
      for r in r_list:
         for lbda in lbda_list:
            f.write("r={} lbda={} value={}\n".format(r,lbda,myfunc(r,lbda,R)))

if __name__=="__main__":
   results_table()
   main()



