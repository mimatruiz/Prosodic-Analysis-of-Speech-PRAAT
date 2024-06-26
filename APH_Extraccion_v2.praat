# LFA - Universitat de Barcelona 
# M.Mateo - Script análisis Prosódico
# Modificado por D. Fuentes-Grandón
# Modificado por Miguel Mateo (abril 2021)
# Modificado por Miguel Mateo (septiembre - nov 2022): estandarización y distancias
# M. Mateo Mayo 23: diferentes tipos de audio (variable), siempre el mismo
# M.Mateo Marzo 24: estandarización distancias
clearinfo
# #########################################################################
# Definición de directorios de trabajo
# datos: Corpus a analizar 
# #########################################################################

form APH - Análisis Prosódico del Habla - Extracción dinámica y rítmica (v2)
comment a) Directorio de los archivos del corpus (sonido+textgrid)
  text dirdatos 
comment Indique el tipo de fichero de audio (wav,mp3,nsp,aiff,flac)
  text audio wav
comment b) Directorio de los ficheros de intensidad (picos) y tiempos
  text dirintd 
endform
# ########################################################################
# Validamos tipo de audio
# ########################################################################
if audio$ <> "wav" and audio$ <> "mp3" and audio$ <> "nsp" and audio$ <> "aiff" and audio$ <> "flac"
   exit Tipo audio no correcto
endif 
####################################################
#creación de tablas
id_table_ficheros = Create Table with column names: "ficheros", 0, "Filename sexo Sílaba Alarma_Pic_pitch Inicio_sílaba Fin_sílaba HZ Tiempo_hz dB_Inicio dB_fin dB_MAX Tiempo_dB_MAX Hz_en_dB_MAX dB_MIN Tiempo_dB_MIN Perc CE Porc_Dist Dist_Est"
filas_ficheros = 0
# ####################################
# Creamos lista de ficheros a procesar
# ###################################
#
id_string = Create Strings as file list... list 'dirdatos$'\*.TextGrid
numberOfFiles = Get number of strings
#
for ifile to numberOfFiles
  select Strings list
  sonido$ = Get string... ifile
  id_TextGrid = Read from file... 'dirdatos$'\'sonido$'
  textgrid$= selected$("TextGrid")
  fichero$ = selected$("TextGrid")

#creación de tablas
  id_table_ficheros = Create Table with column names: "ficheros_"+sonido$, 0, "Sílaba pico_intens Tiempo_pico Hz_en_pico_int Porc_Int CE_Int Dist_Picos Porc_Dist Dist_Est"
  filas_ficheros = 0

#  
# Generamos el fichero de pitch a partir de fichero original
# en función de si se ha informado que la voz era masculina (m) o 
# femenina (f)
# 
  select TextGrid 'textgrid$'
  n = Get number of intervals... 1
# ###########################################
# Buscamos información de si la voz es femenina o masculina
# ########################################## 
  voz$ =""
  for i to n
    silaba$ = Get label of interval... 1 i
    if i = 1 or i = n
      if silaba$ = "f" or silaba$ = "F"
        voz$ ="f"
      else 
        if silaba$ = "m" or silaba$ = "M" 
          voz$ ="m"
        endif
      endif
    endif
  endfor
# ########################################################################
# Validamos que está informado tipo de voz
# ########################################################################
  if voz$=""
   exit Textgrid no correcto, falta informar si la voz es masculina (m) o femenina (f)
  endif 
# #######################################################
#  Creación fichero pitch
# #######################################################
  id_sound = Read from file... 'dirdatos$'\'textgrid$'.'audio$'
  select Sound 'textgrid$'
 if voz$ = "f"
    pitch = To Pitch (ac)... 0.02 90 15 yes 0.03 0.25 0.01 0.35 0.14 600
    sexo = 5500
  else
    pitch = To Pitch (ac)... 0.02 40 15 yes 0.03 0.25 0.01 0.35 0.14 350
    sexo = 5000
  endif
# #######################################################
#  Creación del objeto intensity
# #######################################################
  selectObject: id_sound
  id_intensity =  To Intensity: 100, 0, "yes"
  select TextGrid 'textgrid$'
  n = Get number of intervals... 1
# ###########################################
# Bucle principal para cada sílaba informada (*)
# ########################################## 
  for i to n
    silaba$ = Get label of interval... 1 i
    if (silaba$ <> "" and silaba$ <> "f" and silaba$ <> "m" and silaba$ <> "F" and silaba$ <> "M")   
     ti = Get starting point... 1 i
     ti$ = fixed$ (ti, 8)
     tf = Get end point... 1 i
     tf$ = fixed$ (tf, 8)
     select pitch
             
# ############################# 
# Inicializamos las variables
# #############################
      i$ = fixed$ (i, 0)        
      grabo= 0
      grabo$ = fixed$ (grabo, 0)
      control = 0
      control$ = fixed$ (control, 0)
      f0_i = 0
      f0_i$ = fixed$ (f0_i, 0)
      f0_ib = 0
      f0_ib$ = fixed$ (f0_ib, 0)
      f0_ibus = 0
      f0_ibus$ = fixed$ (f0_ibus, 0)
      f0_f = 0
      f0_f$ = fixed$ (f0_f, 0)
      f0_fb = 0
      f0_fb$ = fixed$ (f0_fb, 0)
      f0_fbus = 0
      f0_fbus$ = fixed$ (f0_fbus, 0)
      f0 = 0
      f0$ = fixed$ (f0, 0)
      min_f0 = 0
      min_f0$ = fixed$ (min_f0, 0)
      max_f0 = 0
      max_f0$ = fixed$ (max_f0, 0)

# ############################
# Variables para información de seguimiento (puts)
# en ejecución normal : N
# ###########################
      imprimir$ = "N"
      imprimirtodo$ = "N"       
      sigo$ ="N"
#
#
#
# Asignamos valor 0,si sistema no ha podido asignar inicial y final.
# Intentamos buscar el primero informado, si lo encontramos, lo informamos. 
# Convertimos los valores a enteros.
# Los valores se informarán manualmente.
#        
#
##########################
#Se llama al procedure de análisis
##########################  
      @analisis
   
# ######################
# Llamada al análisis de intensidad
# ######################
      @analisis_intensity
# #######################
# LLamada al procedimiento de grabación de cada sílaba en el fichero,
# después volvemos a seleccionar textgrid, porque se
# desselecciona en el proceso
# ################################
#
      call grabacion  'silaba$' 'f0_i$' 'f0_f$' 'f0$' 'min_f0$' 'max_f0$' 'grabo$' 'fichero$' 'dirintd$' 'dirf0r$'
      select TextGrid 'textgrid$'

# #################################
# Fin bucle de cada sílaba (**)
# ##############################################
#
    endif
  endfor
# ##############################################
#lIMPIEZA de objetos dentro del primer loop
# ##############################################
  selectObject: id_TextGrid
  plusObject: id_sound
  plusObject: pitch
  plusObject: id_intensity
  #plusObject: id_manipulation_pitch
  #plusObject: new_pitch
  Remove
endfor
# ######################
# Llamada al análisis de ritmo
# ######################
#     @ritmo
# ######################
# Fin análisis de ritmo
# ######################
# ##############################################
#lIMPIEZA de objetos final
# ##############################################
selectObject: id_string
Remove
# 
# ###############################################################################################
# 
# Grabación del fichero con todos los datos informados
#
# Valor 8 se graba cuando no se ha podido obtener algún dato y se graba a 0
# Además de grabar el fichero normal con el dato a 0, lo grabamos en el directorio "Revisar", 
# en el que quedarán todos los enunciados con análisis procedure.
#
# ###############################################################################################
#
procedure grabacion .silaba$ .f0_i$ .f0_f$ .f0$ .min_f0$ .max_f0$ .grabo$ .fichero$ .dirintd$ .dirf0r$
#
#

  if grabo$="8" or grabo$="0"
    @tabla_ficheros: silaba$, ti, tf, f0, tiempo_max_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0, "HZ Tiempo_hz dB Tiempo_dB Perc CE Porc_Dist Dist_Est"
  endif   
	if grabo$="1" and control$ = "0"
    @tabla_ficheros: silaba$, ti, tf, f0, tiempo_max_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
  endif
# ########
# No grabamos más de 1 valor por sílaba
# ###############################
  if grabo$="2" and control$ = "0"
    @tabla_ficheros: silaba$, ti, tf, f0_i, ti,  inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "*", ti, tf, min_f0, tiempo_min_f0,  inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
  endif
  if grabo$="3" and control$ = "0"
     @tabla_ficheros: silaba$, ti, tf, f0_i, ti,  inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0, 
#    @tabla_ficheros: silaba$ + "*", ti, tf, max_f0, tiempo_max_f0,  inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
  endif
  if grabo$="4" and control$ = "0"
     @tabla_ficheros: silaba$, ti, tf, f0_i, ti,  inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "*", ti, tf, min_f0, tiempo_min_f0,  inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "**", ti, tf, f0_f, tf,  inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
  endif
  if grabo$="5" and control$ = "0"
   @tabla_ficheros: silaba$, ti, tf, f0_i, ti,  inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
#·   @tabla_ficheros: silaba$ + "*", ti, tf, max_f0, tiempo_max_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "**", ti, tf, f0_f, tf, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "no", 0, 0, 0, 0,
  endif
# ############################################################################################
#  Grabamos fila en el fichero de datos a revisar si está activada la variable
#  de control de valores extremos.         
# ############################################################################################   
	if grabo$="1" and control$ = "1"
    #@tabla_ficheros: silaba$, ti, tf, f0:0, f0, tiempo_max_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
    @tabla_ficheros: silaba$, ti, tf, f0, tiempo_max_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
  
  endif
# ########
# No grabamos más de 1 valor por sílaba
# ###############################
   if grabo$="2" and control$ = "1"

   @tabla_ficheros: silaba$, ti, tf, f0_i, ti, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0, 
#    @tabla_ficheros: silaba$ + "*", ti, tf, min_f0, tiempo_min_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
  endif
  if grabo$="3" and control$ = "1"

    @tabla_ficheros: silaba$, ti, tf, f0_i, ti, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "*", ti, tf, max_f0, tiempo_max_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
  endif
  if grabo$="4" and control$ = "1"

    @tabla_ficheros: silaba$, ti, tf, f0_i, ti, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "*", ti, tf, min_f0, tiempo_min_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "**", ti, tf, f0_f, tf, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
  endif
  if grabo$="5" and control$ = "1"

   @tabla_ficheros: silaba$, ti, tf, f0_i, ti, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "*", ti, tf, max_f0, tiempo_max_f0, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
#    @tabla_ficheros: silaba$ + "**", ti, tf, f0_f, tf, inicio_intensidad, final_intensidad, maximo_intensidad, tiempo_maximo_intensidad, pitch_dB_MAX, minimo_intensidad, tiempo_minimo_intensidad, "sí", 0, 0, 0, 0,
 endif    																
endproc
#
# ##################################################### 
# Buscamos primer valor informado del segmento tonal
# ######################################################
procedure primero .ti$ .tf$ .f0_i$
  if sigo$ = "S"
    echo Valores
    printline entro búsqueda primero
  endif 
#
#
#
  numberOfTimeSteps = ('tf$' - 'ti$') / 0.001
  step = 1
  repeat
    tmin = 'ti$' + (step - 1) * 0.001
    tmax = tmin + 0.001
    f0_ib= Get mean... tmin tmax Hertz
    f0_ibus$ = fixed$ (f0_ib, 0)
    if f0_ibus$ = "--undefined--"   	    
      f0_ibus$ = "0" 
    endif 
    step = step + 1
  until ('f0_ibus$' > 0) or (step = numberOfTimeSteps)
#
#
endproc
# ############################################################
# Buscamos último valor informado del segmento tonal
# #############################################################
procedure ultimo .ti$ .tf$ .f0_f$
  if sigo$ = "Z"
    echo Valores
    printline entro búsqueda último
  endif 
  numberOfTimeSteps = ('tf$' - 'ti$') / 0.001
  step = 1
  repeat
    tmin = 'tf$' - (step * 0.001)
    tmax = tmin + 0.001
    f0_fb= Get mean... tmin tmax Hertz
    f0_fbus$ = fixed$ (f0_fb, 0)
    if f0_fbus$ = "--undefined--"   	    
      f0_fbus$ = "0" 
    endif 
    step = step + 1
  until ('f0_fbus$' > 0) or (step = numberOfTimeSteps)
endproc
procedure tabla_ficheros: valor_segmento$, ti, tf, valor_Hz, tiempo_hz, valor_dB_inicio, valor_dB_fin, valor_dB_maximo, tiempo_dB_maximo, hz_on_dB_MAX, valor_dB_minimo, tiempo_dB_minimo, alarma_pitch$, valor_Perc, valor_CE, Porc_Dist, Dist_Est,
  filas_ficheros = filas_ficheros + 1
  selectObject: id_table_ficheros
  tf3$ = fixed$ (tf, 3)
  valor_dB_maximo3$ = fixed$ (valor_dB_maximo,3)
  tiempo_dB_maximo3$ = fixed$ (tiempo_dB_maximo,3)
  hz_on_dB_MAX3$ = fixed$ (hz_on_dB_MAX,0)
  Append row
   if valor_segmento$ <> "Z" or valor_segmento$ <> "z" 

  Set string value: filas_ficheros, "Sílaba", valor_segmento$
  Set string value: filas_ficheros, "pico_intens", valor_dB_maximo3$ 
  Set string value: filas_ficheros, "Tiempo_pico", tiempo_dB_maximo3$ 
  Set string value: filas_ficheros, "Hz_en_pico_int", hz_on_dB_MAX3$ 
   Set numeric value: filas_ficheros, "Porc_Int", 0
   Set numeric value: filas_ficheros, "CE_Int", 0
   Set numeric value: filas_ficheros, "Dist_Picos", 0
   Set numeric value: filas_ficheros, "Porc_Dist", 0
   Set numeric value: filas_ficheros, "Dist_Est", 0
  Save as comma-separated file: dirintd$ + textgrid$ + ".txt"
   endif
   if valor_segmento$ = "Z" or valor_segmento$ = "z"
   Set string value: filas_ficheros, "Sílaba", valor_segmento$
   Set numeric value: filas_ficheros, "pico_intens", 0
   Set string value: filas_ficheros, "Tiempo_pico", tf3$
   Set numeric value: filas_ficheros, "Hz_en_pico_int", 0
   Save as comma-separated file: dirintd$ + textgrid$ + ".txt"
   endif
endproc

###############################################################
#Procedure de análisis
#Se aplicará en distintas instancias y con distintos objetos pitch
###############################################################
procedure analisis
  f0 = Get mean... ti tf Hertz
  f0$ = fixed$ (f0, 0)
  if f0$ = "--undefined--"  
    f0$="0"
    f0 = 0
  endif 
  min_f0 = Get minimum... ti tf Hertz Parabolic
  min_f0$ = fixed$ (min_f0, 0)
  if min_f0$ = "--undefined--"   
    min_f0$ = "0"
    tiempo_min_f0 = undefined
  else
    tiempo_min_f0 = Get time of minimum: ti, tf, "Hertz", "Parabolic"
  endif
  max_f0 = Get maximum... ti tf Hertz Parabolic
  max_f0$ = fixed$ (max_f0, 0)
  if max_f0$ = "--undefined--"
    max_f0$ = "0"
    tiempo_max_f0 = undefined
  else
    tiempo_max_f0 = Get time of maximum: ti, tf, "Hertz", "Parabolic"
  endif
# ######################################################
# Si no hay información de pitch en el segmento tonal,
# no real:izamos la búsqueda
# #######################################################
      if f0$ = "0" and min_f0$ = "0" and max_f0$ = "0"
        f0_i$ = "0"
        f0_f$ = "0"
      else
        f0_i = Get value at time... ti Hertz Linear
        f0_i$ = fixed$ (f0_i, 0)
        if f0_i$ ="--undefined--"         
          f0_i$ = "0"
          call primero 'ti$' 'tf$' 'f0_i$'
          f0_i = f0_ib
          f0_i$ = fixed$ (f0_i, 0)
          if f0_i$ = "--undefined--"        
            f0_i$ = "0" 
          endif    
        endif
        f0_f = Get value at time... tf Hertz Linear
        f0_f$ = fixed$ (f0_f, 0)
        if f0_f$ = "--undefined--"
          f0_f$ = "0"
          call ultimo 'ti$' 'tf$' 'f0_f$'
          f0_f = f0_fb
          f0_f$ = fixed$ (f0_f, 0)
          if f0_f$ = "--undefined--"
            f0_f$ = "0"
          endif
        endif
      endif         
#
# ########################
#   Valores para seguimiento, según variable imprimir, se pueden añadir más condiciones   
# #########################      
#      
      if imprimir$ = "S" and i=30
        echo Valores :
        printline grabacion : 'grabo$'
        printline i : 'i$'
        printline sílaba : 'silaba$'
        printline inicio : 'ti$'
        printline fin : 'tf$'
        printline f0_i: 'f0_i$'
        printline f0_ibuscado : 'f0_ibus$'
        printline f0_fbuscado : 'f0_fbus$'
        printline f0_f : 'f0_f$'
        printline f0 : 'f0$'
        printline min_f0 : 'min_f0$'
        printline max_f0 : 'max_f0$'

      endif
#
# Si alguno de los valores está a 0 (el sistema no ha podido calcular)imprimiremos directamente.
# Los valores se informarán manualmente en el fichero resultado  (***)
# 
      if f0_i$ ="0" or f0_f$ ="0" or f0$ ="0" or min_f0$ ="0" or max_f0$ ="0"
        grabo$ = "8"
      else     
# 
# (1) Validación de valores extremos 
#   90 y 550 --> female
#   60 y 350 --> male
#  para generar alerta en fichero de revisión
#
        if (voz$ = "f" and ((f0_i > 550 or f0_f > 550 or f0 > 550 or min_f0 > 550 or max_f0 > 550) or (f0_i < 90 or f0_f < 90 or f0 < 90 or min_f0 < 90 or max_f0 < 90)))
          control$ ="1"
        endif
        if (voz$ = "m" and ((f0_i > 350 or f0_f > 350 or f0 > 350 or min_f0 > 350 or max_f0 > 350) or (f0_i < 60 or f0_f < 60 or f0 < 60 or min_f0 < 60 or max_f0 < 60)))
         control$ ="1"
        endif
#
#
#
# (2) Asignamos los márgenes inferior y superior -actualmente 10%- 
# ##################
# Eliminar margen
# #############
#
# (3) real:izamos las verificaciones para decidir qué valores  grabaremos.
#
# ########################
#   Valores para seguimiento, según variable imprimir, se pueden añadir más condiciones   
# #########################
        if imprimirtodo$ = "S" and i=10
          echo Valores :
          printline grabacion : 'grabo$'
          printline control : 'control$'
          printline i : 'i$'
          printline sílaba : 'silaba$'
          printline inicio : 'ti$'
          printline fin : 'tf$'
          printline f0_i: 'f0_i$'
          printline f0_ibuscado : 'f0_ibus$'
          printline f0_fbuscado : 'f0_fbus$'
          printline f0_f : 'f0_f$'
          printline f0 : 'f0$'
          printline min_f0 : 'min_f0$'
          printline max_f0 : 'max_f0$'
        endif
# ######################################################
# Fin verificación de lo que tenemos que grabar (***)
# ######################################################
#
      endif
endproc
procedure analisis_intensity
  selectObject: id_intensity
  promedio_dB = Get mean: ti, tf, "dB"
  maximo_intensidad = Get maximum: ti, tf, "Parabolic"
  minimo_intensidad = Get minimum: ti, tf, "Parabolic"
  tiempo_maximo_intensidad = Get time of maximum: ti, tf, "Parabolic"
  tiempo_minimo_intensidad = Get time of minimum: ti, tf, "Parabolic"
  inicio_intensidad = Get value at time: ti, "Cubic"
  final_intensidad = Get value at time: tf, "Cubic"
  selectObject: pitch
  pitch_dB_MAX = Get value at time: tiempo_maximo_intensidad, "Hertz", "Linear"
endproc





