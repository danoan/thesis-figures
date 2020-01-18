class Param:
    def __init__(self,name,prefix,type,items,resolver):
        self.name=name
        self.prefix=prefix
        self.type=type
        self.items=[ {'path':resolver(prefix,v),'value':v} for v in items]

GRID_STEP=[1.0,0.5,0.25]
SHAPES=["bean","square","flower","triangle","ellipse"]
RADIUS=[3,5,10]
ESTIMATOR=["ii","mdca"]
ENERGY=["elastica","selastica"]
LENGTH_PENALIZATION=[0.001,0.005,0.01]
ITERATIONS=400
MIN_CURVE_LENGTH=2
MAX_CURVE_LENGTH=50
NUM_JONCTIONS=[1]
STRATEGY=["best"]
NUM_THREADS=32

def resolve_double(prefix,d):
    return "%s%.5f" % (prefix,d,)

def resolve_int(prefix,i):
    return "%s%d" % (prefix,i,)

def resolve_std(prefix,s):
    return "%s%s" % (prefix,s)

def valid_combination(c):
    shape,radius,estimator,energy,length_pen,jonctions,strategy,gs = c

    flag=True
    if estimator=="mdca":
        flag= flag and radius==3

    return flag

Param("Shape","sp","shape",SHAPES,resolve_std),

CONFIG_LIST=[ Param("Shape","","shape",SHAPES,resolve_std),
              Param("Radius","radius_","radius",RADIUS,resolve_int),
              Param("Estimator","","estimator",ESTIMATOR,resolve_std),
              Param("Energy","","energy",ENERGY,resolve_std),
              Param("Length Penalization","len_pen_","lenght_pen",LENGTH_PENALIZATION,resolve_double),
              Param("Jonctions","jonctions_","jonctions",NUM_JONCTIONS,resolve_int),
              Param("Strategy","","strategy",STRATEGY,resolve_std),
              Param("Grid Step","gs_","grid_step",GRID_STEP,resolve_double)]




