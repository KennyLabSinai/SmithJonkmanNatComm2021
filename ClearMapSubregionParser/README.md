## Instructions for using Python code for parsing ClearMap cell counts into subregions - written by Alexander C.W. Smith, alexander.smith@mssm.edu
### This code relies on outputs from the ClearMap package. The ClearMap documentation with installation instructions is included here, and code can be found at www.github.com/christophkirst/clearmap

### System requirements:
Tested on Linux Ubuntu 18.04LTS, but should work on Mac OSX & Windows. The clearMapSubregionParser.py script will run in either Python 2.7 or 3.X, though ClearMap runs on Python2.7.

Requied python libraries are specified in requirements.txt.

### Installation instructions:
1) Clone this repository
2) Open a terminal/command prompt inside the ClearMapSubregionParser directory.
3) Install pip (if not already installed)
    ```
    sudo apt install python3-pip
    ```
4) Install dependencies (approximately 2-3 minutes depending on internet connection speed):
    ```
     python3 pip install -r requirements.txt
    ```
5) Make the parser script executable:
    ```
    sudo chmod +x clearMapSubregionParser.py
    ```
### Run the code (expected time 5-15 seconds):

    $ python3 clearMapSubregionParser.py --directory ./  --hemisphere 'left' --samples IA1_LB --save True

### Expected Text Output:

    Validated correct split
    mouse  aDLS  mDLS  pDLS  aDMS  mDMS  pDMS
    IA1_LB   151   283   157   149   410   172

### Expected CSV file output: 
IA1_LB_Striatum_Subregion_Counts_left.csv
