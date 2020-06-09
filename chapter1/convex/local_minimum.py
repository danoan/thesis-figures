import os
PROJECT_FOLDER=os.path.dirname(os.path.realpath(__file__))

from chanvese.chanvese import chanvese
import numpy as np
from skimage.io import imread
from scipy.signal import convolve
import matplotlib.pyplot as plt

INPUT_FOLDER="{}/input".format(PROJECT_FOLDER)
OUTPUT_FOLDER="{}/output/convex".format(PROJECT_FOLDER)
ITERATIONS=100

os.makedirs(OUTPUT_FOLDER,exist_ok=True)

NEIGH=np.array( [ [0,-1,0],[-1,4,-1],[0,-1,0] ] )
def compute_energy_value(I,phi,lbda):
   H=np.zeros(I.shape)
   H[phi>=0]=1
   perimeter = np.sum( np.abs( convolve(H,NEIGH) ) )

   region = np.sum( (H-I)**2 )

   return 1.0/lbda*perimeter + region
 

def execute_chanvese(lbda,input_filepath):
   img = imread(input_filepath,as_gray=True)
   m = img.copy()
   seg,phi,its=chanvese(img, m, max_its=ITERATIONS, display=False, alpha=1.0/lbda)
   ev=compute_energy_value(img,phi,lbda)

   return img,phi,ev

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

def best_phi():
   img,phi,ev = execute_chanvese(0.5,"{}/ball.png".format(INPUT_FOLDER))

   img_mixnoisy = imread("{}/ballmixnoisy.png".format(INPUT_FOLDER),as_gray=True)
   save_fig(img_mixnoisy,phi,"{}/reference_contour.png".format(OUTPUT_FOLDER),False) 
   return phi

def main():
   input_filepaths=["ballmixnoisy.png"]
   bphi=best_phi()

   with open("{}/report.txt".format(OUTPUT_FOLDER),"w") as f:
      lbda_list=[3,1,0.5]
      for filepath in input_filepaths:
         for lbda in lbda_list:
            img,phi,ev = execute_chanvese(lbda,"{}/{}".format(INPUT_FOLDER,filepath))
            save_fig(img,phi,"{}/out_lbda_{}_{}".format(OUTPUT_FOLDER,lbda,filepath)) 
            bphi_value = compute_energy_value(img,bphi,lbda)
            f.write("{} lbda= {} value={} bphi={}\n".format(filepath,lbda,ev,bphi_value))

if __name__=="__main__":
   main()



