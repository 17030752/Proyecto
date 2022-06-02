# SISTEMA-EXPERTO-PARA-EL-CONTROL-CALORICO
### EXPERT-SYSTEM-FOR-HEAT-CONTROL
* INSTITUTO TECNOLOGICO DE CELAYA
* PERIOD ENE-JULY
* YEAR: 2022
* SUBJECT: LOGIC AND FUNCTIONAL PROGRAMMING

Description.


System designed for the diagnosis of body mass of people in the stages of childhood, youth, adulthood.

The application uses MyQSL database and swi-prolog for its operation it is important to configure the odbc connector mysql.
with the following data:


+ **DSN: prolog**
+ **DATABASE : bdprolog**
+ **user: (user to be used)**
+ **password: (password to use)**
+ **port: (port to use)**


## additional notes


* The database inside contains a log table named "medical_log or registro_medico in spanish".


* The libraries used by prolog are:
   + func
   + function_expansion
   + interpolate
   + list_util


**They are all installed by means of the command [ pack_install("library name") ].**
