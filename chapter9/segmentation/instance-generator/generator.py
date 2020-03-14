from __init__ import *
import subprocess,sys,os,time

from param_combinator import *
from config import *
from template_render import *
from shutil import copyfile
import threading,time


SCRIPT_FOLDER = os.path.dirname( os.path.realpath(__file__) )
PROJECT_FOLDER = SCRIPT_FOLDER
for i in range(3):
    PROJECT_FOLDER = os.path.dirname(PROJECT_FOLDER)

BINARY_FOLDER="{}/{}".format(PROJECT_FOLDER,"ext-projects/cmake-build-release/bin")
JMIV_BINARY_FOLDER="{}/{}".format(PROJECT_FOLDER,"ext-projects/cmake-build-release/jmiv/bin")
INPUT_FOLDER="{}/{}".format(SCRIPT_FOLDER,"input")

BASE_DATA_FOLDER="{}/{}".format(SCRIPT_FOLDER,"data")

def resolve_path_folder(c):
    path_folder=""
    for e in c:
        path_folder += "/" + e['path']

    return path_folder


def graphseg(c):
    model,dalpha,neigh,alpha,beta,lb,lr,input_name = c

    dataFolder = "{}/{}".format(BASE_DATA_FOLDER,resolve_path_folder(c))
    os.makedirs(dataFolder,exist_ok=True)

    dalpha_str="-A" if dalpha["value"] else " "

    plist= ["-i{}".format(200),
            "-r{}".format(7),
            "-e{}".format("elastica"),
            "-h{}".format(0.25),
            "-a{}".format(alpha["value"]),
            "-k{}".format(beta["value"]),
            "-b{}".format(lb["value"]),
            "-g{}".format(lr["value"]),
            "-O{}".format(2),
            "-N{}".format(neigh["value"]),
            "-n{}".format(6),
            "{}/{}.xml".format(INPUT_FOLDER,input_name["value"]),
            dataFolder
            ]

    print("\n*****Running: ", " ".join(plist),"\n")

    binary = "{}/{}".format(BINARY_FOLDER,"graph-seg-app")
    subprocess.call( [binary] + plist )

def flipseg(c):
    model,dalpha,neigh,alpha,beta,lb,lr,input_name = c

    dataFolder = "{}/{}".format(BASE_DATA_FOLDER,resolve_path_folder(c))
    os.makedirs(dataFolder,exist_ok=True)

    plist= ["-i{}".format(200),
            "-r{}".format(7),
            "-g{}".format(alpha["value"]),
            "-q{}".format(beta["value"]),
            "-t{}".format(lr["value"]),
            "-d{}".format(0),
            "-l{}".format(-2),
            "{}/{}.xml".format(INPUT_FOLDER,input_name["value"]),
            "-o{}".format(dataFolder)
            ]

    print("\n*****Running: ", " ".join(plist),"\n")

    binary = "{}/{}".format(JMIV_BINARY_FOLDER,"boundary-correction-app")
    subprocess.call( [binary] + plist )


def balanceseg(c):
    model,dalpha,neigh,alpha,beta,lb,lr,input_name = c

    dataFolder = "{}/{}".format(BASE_DATA_FOLDER,resolve_path_folder(c))
    os.makedirs(dataFolder,exist_ok=True)

    plist= ["-i{}".format(200),
            "-r{}".format(7),
            "-g{}".format(alpha["value"]),
            "-q{}".format(beta["value"]),
            "-t{}".format(lr["value"]),
            "-d{}".format(0),
            "-O{}".format(1),
            "-l{}".format(-2),
            "{}/{}.xml".format(INPUT_FOLDER,input_name["value"]),
            "-o{}".format(dataFolder)
            ]

    print("\n*****Running: ", " ".join(plist),"\n")

    binary = "{}/{}".format(BINARY_FOLDER,"boundary-correction-app")
    subprocess.call( [binary] + plist )

def empty_pool():
    while threading.activeCount()>20:
        time.sleep(2)
        print("Waiting some work to finish...")


def total_combinations():
    total=0
    combs = combinations(CONFIG_LIST)
    for c in combs:
        if valid_combination(c):
            total+=1
    return total

def trigger(c):
    model,dalpha,neigh,alpha,beta,lb,lr,input_name = c

    if model["value"]=="balanceseg":
        model_fn = balanceseg
    elif model["value"]=="flipseg":
        model_fn = flipseg
    elif model["value"]=="graphseg":
        model_fn = graphseg
    else:
        print("Model not recognized")


    TE=threading.Thread(None,empty_pool())
    TE.start()
    TE.join()
    threading.Thread(None,lambda:model_fn(c)).start()


def main():
    print("Total combinations: ",total_combinations())
    for c in combinations(CONFIG_LIST):
        if(valid_combination(c)):
            trigger(c)


if __name__=='__main__':
    # T=threading.Thread(None,main)
    # T.start()
    # T.join()
    render_template("seg",CONFIG_LIST,BASE_DATA_FOLDER)
