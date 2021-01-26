# Bolt_Tool

#The tool is designed to run in Altair HyperMesh software.

#Inside Hypermesh, choose File>>Run>>TCL/tk script

#The tool use a .txt file as a database. This database can be loaded into the tool

#Each bolted joint is created with an identification number base on the number of the bolt type in the .txt file

#The PROD, 2 PBUSH ids are named and identified according to the above number

#A demo video is available at: https://youtu.be/eZA82MRigbQ

#Each bolted joint created by the above tool is assigned with an unique id shown in the name of PROD and PBUSH properties. 

#The analysis can be run with Altair OptiStruct solver (or a Nastran based solver with some small modfication).

#The analysis result should be output with a *.pch* file

#the Bolt_force_calculationv3.py is a python script used to evaluate the loads applied on each bolted joint.

#to use this tool:

  1. Change *.fem* file name to *opt_file.fem*
  
  2. Change *.pch* file name to *opt_file.pch*
  
  3. Put above files in the same folder with the *Bolt_force_calculationv3.py* file
  
  4. Run the script, the force result is stored in force_dict dictionary. 
