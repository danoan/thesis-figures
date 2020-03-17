class Param:
    def __init__(self,name,prefix,type,items,resolver,render=True):
        self.name=name
        self.prefix=prefix
        self.type=type
        self.items=[ {'path':resolver(prefix,v),'value':v} for v in items]
        self.render=render


MODEL=["balanceseg","flipseg","graphseg"]
H=[1.0]
ALPHA=[0,0.1,0.5,1.0,3.0]
DALPHA=[True,False]
BETA=[0,0.1,1.0,3.0]
LB=[0.0,0.5,1.0,2.0,5.0]
LR=[0.0,0.5,1.0,2.0,5.0]
NEIGH=[0,1,2]


INPUT_NAME=["coala"]

def resolve_double(prefix,d):
    return "%s%.1f" % (prefix,d,)

def resolve_int(prefix,i):
    return "%s%d" % (prefix,i,)

def resolve_std(prefix,s):
    return "%s%s" % (prefix,s)

def valid_combination(c):
    model,h,dalpha,neigh,alpha,beta,lb,lr,input_name = c

    flag=True
    if dalpha["value"]==True:
        flag = flag and alpha["value"]==0 and model["value"]=="graphseg"

    if neigh["value"]>0:
        flag = flag and model["value"]=="graphseg"


    if neigh["value"]==0 and model["value"]=="graphseg":
        flag = flag and alpha["value"]==0

    return flag

CONFIG_LIST=[ Param("Model","","model",MODEL,resolve_std,False),
              Param("H","","h",H,resolve_double,True),
              Param("DAlpha","dalpha-","dalpha",DALPHA,resolve_std),
              Param("Neighborhood","neigh-","neigh",NEIGH,resolve_int),
              Param("Alpha","alpha-","alpha",ALPHA,resolve_double),
              Param("Beta","beta-","beta",BETA,resolve_double),
              Param("LambdaB","lb-","lb",LB,resolve_double),
              Param("LambdaR","lr-","lr",LR,resolve_double),
              Param("InputName","","input_name",INPUT_NAME,resolve_std)]




