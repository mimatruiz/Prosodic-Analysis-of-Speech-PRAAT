# Prosodic-Analysis-of-Speech-PRAAT
1.Introduction

The aim of this document is to elucidate the installation process and the procedure for running PRAAT programs (scripts) and associated Excel documents, along with their macros. These tools are employed for extracting data related to peak intensity and the temporal distances between them (APH). The data obtained through the two scripts is subsequently visualized using an Excel macro linked to a specific file
2.Instalatation procedure

First, you will need to download the PRAAT scripts from this repository and copy them to the same directory where you have PRAAT installed.
You should obtain 3 files: the two method scripts (APH) and a third one that allows you to add the previous ones as Menu options to PRAAT (setup.praat).
To do this, open PRAAT and from the Praat menu, option “Open Praat script…” open the setup.praat file, which we have mentioned.

 ![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/b1b8eb97-6437-4150-af5d-82618a3d5980)

![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/d57edca5-bce2-43b9-80ab-ab028be04b9b)

Once the file is open, from Praat, press Run (main and submenu):

 ![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/96ca6cef-ae46-4339-ab43-75abe4b2ea5e)

The result will be a new menu in the Praat option, one for each script, with the two options of our methodology, for prosodic analysis (extraction and standardization).

![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/4eeac8dd-17a7-4094-82e6-921d12d29fb9)



3. Execution of the scripts

In each of the options, the script asks on the screen for the complete directories of the various input files or those that are generated as a result. Therefore, it is advisable to have the directory where we are going to perform our analysis well organized, when executing the two scripts, as we will see; we are going to need three files in total. A proposal would be:
C:\Users\MMR\APH\XXXX\
Where:
MMR: would be your base “folder”, APH would be the general folder for the prosodic analysis and XXXXX will take three values, the three folders of the entire process:
Corpus: data that we are going to analyze (sound and Textgrid), they are the input files to the data extraction script, (the same as for AMH data extraction)
IntTiempo: In this folder, the files will be generated with the data of intensity peaks (decibels) and time (second); output of the APH_Extraction script.
CDináDist: in this folder, we will have the files to obtain the standardized intensity curve (dynamic analysis) and the time distances between them); output of the APH_Standardization script.

<img width="404" alt="image" src="https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/ffb7603e-cc8e-4686-8e09-74ab66914e03">

Let us see, below, how to run each of the two scripts.

3.1 APH Extraction

The operation is similar to that used in AMH, we have two scripts: the first (APH_Extraccion_v2) obtains the intensity peaks of each tonal segment and the time point at which they occur; the second (APH_Standardizacion_v2), allows us to obtain the standardized curve of the dynamic analysis (intensity peaks) and the distances between the previous intensity peaks.
When we execute the APH_Extraccion_v2 script, from the Praat\LFA_UB menu, the following screen appears, in which we must inform the folder with the corpus (sound+textgrid). It is the same as the input in the first AMH script, and the output, with the files with the intensity and time peak data, one for each element of the corpus.
In APH, there are no alerts, because all segments have a single peak intensity.
 
![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/f8017569-bb31-43b5-bc97-5c58d382968a)

For example:
a) First folder: corpus of data to analyze: sound and Textgrid.
Example: C:\Users\MMR\APH\Corpus\
Audio file type: wav / mp3 / nsp / aiff / flac
b) Second folder: intensity data and distances between intensity peaks
Example: Users\MMR\APH\Corpus\IntTiempo\

In the case of using the scripts in a “Mac” environment, remember that the “\” must be changed to “/”
Example: C:/Users/MMR/APH/Corpus/
Important note: in all cases, the folders/directories must previously exist, to run all the scripts and the directory path must end with \ (Windows) or / (Mac) at the end.


3.2 APH Standardization

Once we obtain  the intensity and time data, we execute the APH_Standardization_v2 script, which presents us with the following screen.
 ![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/afce4c83-18e2-40e9-aa27-a8aa86f4788b)


In it, we will inform in which folder the intensity and time data are in, the result of the previous script (that is, the same folder that we put in b, in the previous script) and the folder in which we will record the standardized intensity curve and the distances between intensity peaks.
For example:
a) First folder: data on tonal peaks and times; output files from the previous script.
Example: C:\Users\MMR\APH\IntTime\
b) Second folder: standardized dynamic curve data (intensity) and distances.
Example: Users\MMR\APH\Corpus\ CDináDist\

In the case of using the scripts in a “Mac” environment, remember that the “\” must be changed to “/”
Example: C:/Users/MMR/APH/Corpus/
To continue with the prosodic analysis, generate the graphs with the standardized dynamic curve and the distances between peaks (bars), go to section (4.2), Excel.
 
4.Excel

4.1 “Instalation”

Download, in the directory/folder where you want to work and save your files with the graphic representations, the following files (Excel and macro)
APH_Automatic_Graphics.xlsm and APH_v3.crtx
Or APH_APH_Gráficos_automático_durint and APH_v9.crtx for the last version, with standardizacion of duration.
We must copy the macros, *.crtx file, to the Excel chart templates directory, for this, with Excel with any file open, to do this, select: Insert\Recommended charts\All charts\Templates\Manage Templates, see image below

 ![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/84edd2fe-a269-42ca-927b-e153c8a33199)

This will open a folder in which we will copy the two files, the APH_v3.crtx macro to create the prosodic analysis graphs (the AMHxxxx macros are for melodic analysis).
 ![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/32e7ad80-e716-4d60-a455-f75ee7a47122)


4.2 Excel APH

We open the model file APH_Gráficos_automático.xlsm and save it with another name, for example, APH_Gráficos_Interrog_Extremadura. xlsm.

 ![image](https://github.com/mimatruiz/Prosodic-Analysis-of-Speech-PRAAT/assets/136570865/dd02232c-881a-4343-93d3-e55d9d88a432)


When we click on the graph generation button, a standard “Windows” file search dialog opens. We must go to the APH_Standardizacion_v2 output folder (in our examples,  C:\Users\MMR\APH\CDináDist\) and select all files: 
And a sheet will be generated for each file, with the graph of the standardized dynamic curve and the bar graph with the temporal distances between the intensity peaks:
