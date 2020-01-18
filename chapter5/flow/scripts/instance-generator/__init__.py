import sys,os

SCRIPT_FOLDER = os.path.dirname( os.path.realpath(__file__) )
PROJECT_FOLDER = SCRIPT_FOLDER
for i in range(4):
    PROJECT_FOLDER = os.path.dirname(PROJECT_FOLDER)

REPORT_GENERATOR_FOLDER="%s/%s" % (PROJECT_FOLDER,"repGen")
print("Including directory: %s in Python search path" % (REPORT_GENERATOR_FOLDER,))
sys.path.append(REPORT_GENERATOR_FOLDER)