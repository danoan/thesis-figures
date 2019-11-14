import subprocess,sys,os

PROJECT_FOLDER="set-via-parameter"
BIN_FOLDER="set-in-read-input"
SCRIPT_FOLDER="set-in-read-input"
BASE_OUTPUT_FOLDER="set-in-read-input"

def recCombinations(maxList,curr,combList):

    if len(maxList)==0:
        combList.append(curr)
        return

    for el in range(0,maxList[0]):
        recCombinations(maxList[1:],curr+[el],combList)

def combinations(configList):
    numParams = len(configList)
    maxList = [ len(el) for el,_ in configList ]

    combList=[]
    recCombinations(maxList,[],combList)

    for c in combList:
        yield tuple( configList[i][0][c[i]] for i in range(numParams) )


GRID_STEP=[1,0.5,0.25]
SHAPES=["square","triangle","flower"]#"wave","square","flower"]#"ball","triangle","pentagon","ellipse"]#"heptagon"]
RADIUS=[3,5]
ESTIMATOR=["mdca","ii"]
ENERGY=["sqc"]
LENGTH_PENALIZATION=[0.01]
ITERATIONS=[400]
MIN_CURVE_LENGTH=[2]
MAX_CURVE_LENGTH=[50]
NUM_JONCTIONS=[1]
STRATEGY=["best"]
NUM_THREADS=[16]


CONFIG_LIST=[ (GRID_STEP,"grid_step"),
              (SHAPES,"shape"), (RADIUS,"radius"), (ITERATIONS,"iterations"),
              (ESTIMATOR,"estimator"),(ENERGY,"energy"),(LENGTH_PENALIZATION,"length_pen"),
              (MIN_CURVE_LENGTH,"mLength"),(MAX_CURVE_LENGTH,"MLength"),(NUM_JONCTIONS,"jonctions"),
              (STRATEGY,"strategy"),(NUM_THREADS,"num_threads")]


def valid_combination(c):
    gs,shape,radius,iterations,estimator,energy,length_pen,mLength,MLength,jonctions,strategy,num_threads = c

    flag=True
    if estimator=="mdca":
        flag= flag and radius==3

    return flag

def resolve_output_folder(gs,shape,radius,iterations,estimator,energy,length_pen,mLength,MLength,jonctions,strategy,num_threads):
    outputFolder = "%s/%s/radius_%d/%s/%s/len_pen_%.5f/m%dM%d/jonctions_%d/%s/gs_%.5f" % (BASE_OUTPUT_FOLDER,shape,radius,
                                                                                          estimator,energy,length_pen,
                                                                                          mLength,MLength,jonctions,strategy,
                                                                                          gs)

    return outputFolder

def flow(c):

    outputFolder = resolve_output_folder(*c)
    gs,shape,radius,iterations,estimator,energy,length_pen,mLength,MLength,jonctions,strategy,num_threads = c

    s=" ".join( ["%s%s" % ("-S",shape),
                 "%s%d" % ("-r",radius),
                 "%s%d" % ("-i",iterations),
                 "%s%s" % ("-e",energy),
                 "%s%f" % ("-a",length_pen),
                 "%s%f" % ("-m",mLength),
                 "%s%f" % ("-M",MLength),
                 "%s%f" % ("-j",jonctions),
                 "%s%s" % ("-s",strategy),
                 "%s%s" % ("-t",estimator),
                 "%s%f" % ("-h", gs),
                 "%s%d" % ("-n", num_threads)
                ])

    print("\n*****Running: ", s,"\n")

    binary = "%s/%s" % (BIN_FOLDER,"app-exhaustive-gc-flow")
    subprocess.call( [binary,
                      "%s%s" % ("-S",shape),
                      "%s%d" % ("-r",radius),
                      "%s%d" % ("-i",iterations),
                      "%s%s" % ("-e",energy),
                      "%s%f" % ("-a",length_pen),
                      "%s%f" % ("-m",mLength),
                      "%s%f" % ("-M",MLength),
                      "%s%f" % ("-j",jonctions),
                      "%s%s" % ("-s",strategy),
                      "%s%s" % ("-t",estimator),
                      "%s%f" % ("-h", gs),
                      "%s%d" % ("-n", num_threads),
                      outputFolder
                      ] )


def total_combinations():
    total=0
    combs = combinations(CONFIG_LIST)
    for c in combs:
        if valid_combination(c):
            total+=1
    return total

def read_input():
    if len(sys.argv)<3:
        print("Parameters missing! PROJECT_FOLDER RELATIVE_BUILD_FOLDER OUTPUT_FOLDER")
        exit(1)

    global PROJECT_FOLDER,BIN_FOLDER, BASE_OUTPUT_FOLDER, SCRIPT_FOLDER
    PROJECT_FOLDER=sys.argv[1]
    BIN_FOLDER="%s/%s" % (PROJECT_FOLDER,sys.argv[2])
    BASE_OUTPUT_FOLDER=sys.argv[3]

def main():
    read_input()
    i=0
    print("Total combinations: ",total_combinations())
    for c in combinations(CONFIG_LIST):
        print("#",i)
        if valid_combination(c):
            flow(c)
        i+=1



if __name__=='__main__':
    main()
