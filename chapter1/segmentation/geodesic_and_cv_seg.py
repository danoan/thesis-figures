import os
PROJECT_FOLDER=os.path.dirname(os.path.realpath(__file__))

import numpy as np
import matplotlib.pyplot as plt

from skimage.segmentation import active_contour as ac
from skimage.segmentation import morphological_geodesic_active_contour as gac
from skimage.segmentation import chan_vese as cv
from skimage.segmentation import inverse_gaussian_gradient
from skimage.io import imread

colors=["#ff0000","#0000ff","#00ff00","#ffff00"]
class ContourGather:
	def __init__(self,it_list):
		self.it=0
		self.it_hold=it_list
		self.evolution=[]

	def callback(self,x):
		self.it+=1
		if self.it in self.it_hold:
			self.evolution.append(x)	

def set_plot_no_axes():
	plt.gca().invert_yaxis()

	plt.gca().set_axis_off()
	plt.subplots_adjust(top = 1, bottom = 0, right = 1, left = 0, 
		    hspace = 0, wspace = 0)
	plt.margins(0,0)
	plt.gca().xaxis.set_major_locator(plt.NullLocator())
	plt.gca().yaxis.set_major_locator(plt.NullLocator())

def active_contour():
	I=imread("{}/input/donuts-2.jpg".format(PROJECT_FOLDER),as_gray=True)
	IColor=imread("{}/input/donuts-2.jpg".format(PROJECT_FOLDER))

	rows,cols=I.shape
	C=[]	
	C.extend( [ [2,x] for x in np.linspace(2,rows-2,20,dtype=np.int32) ] )
	C.extend( [ [x,rows-2] for x in np.linspace(2,cols-2,20,dtype=np.int32) ] )
	C.extend( [ [cols-2,x] for x in np.linspace(rows-2,2,20,dtype=np.int32) ] )
	C.extend( [ [x,2] for x in np.linspace(cols-2,2,100,20,dtype=np.int32) ] )
	C = np.array(C)

	it_hold=[1,300,1200]
	evolutions=[]
	for max_it in it_hold:
		evolutions.append( ac(I,C,max_iterations=max_it) )

	fig, ax = plt.subplots(1,1)
	set_plot_no_axes()
	ax.imshow(IColor)
	for e,i,c in zip(evolutions,it_hold,colors):
		ax.plot( e[:,0],e[:,1],color=c)

	plt.savefig("{}/output/segmentation/active_contour-don.png".format(PROJECT_FOLDER),bbox_inches = 'tight',pad_inches = 0)	


def geodesic_active_contour():
	I=imread("{}/input/donuts-2.jpg".format(PROJECT_FOLDER),as_gray=True)
	IColor=imread("{}/input/donuts-2.jpg".format(PROJECT_FOLDER))

	M=np.zeros( I.shape,dtype=np.int8)
	M[2:-2,2:-2]=1

	gacContour = ContourGather([1,50,300])
	gac( inverse_gaussian_gradient(I),300,init_level_set=M,balloon=-1,threshold=0.78,iter_callback=lambda x:gacContour.callback(x) )


	fig, ax = plt.subplots(1,1)
	set_plot_no_axes()
	ax.imshow(IColor)
	for e,c,i in zip(gacContour.evolution,colors,gacContour.it_hold):
		contour = ax.contour(e, [0.5], colors=c)
		contour.collections[0].set_label("Iteration {}".format(i))

	plt.savefig("{}/output/segmentation/geodesic-seg-don.png".format(PROJECT_FOLDER),bbox_inches = 'tight',pad_inches = 0)	

def chan_vese():
	I=imread("{}/input/donuts-2.jpg".format(PROJECT_FOLDER),as_gray=True)
	IColor=imread("{}/input/donuts-2.jpg".format(PROJECT_FOLDER))

	M=np.zeros( I.shape,dtype=np.float64)

	rows,cols = M.shape
	for r in range(rows):
		for c in range(cols):
			M[r,c] = np.sin(np.pi/25*r)*np.sin(np.pi/25*c)

	it_hold=[1,100,300]
	evolution=[]
	for max_it in it_hold:
		evolution.append( cv(I,init_level_set=M,max_iter=max_it) )

	fig, ax = plt.subplots(1,1)
	set_plot_no_axes()
	ax.imshow(IColor)
	for e,i,c in zip(evolution,it_hold,colors):
		ax.contour(e, [0.5], colors=c)
	
	plt.savefig("{}/output/segmentation/chan-vese-seg-don.png".format(PROJECT_FOLDER),bbox_inches = 'tight',pad_inches = 0)	

if __name__=="__main__":
	os.makedirs("{}/output/segmentation".format(PROJECT_FOLDER),exist_ok=True)
	geodesic_active_contour()
	chan_vese()
	active_contour()
