# LFA - Universitat de Barcelona 
# Miguel Mateo  (Noviembre 2022)
# Análisis prosódico - obtención curva estándar análisis dinámico
# Análisis prosódico - obtención distancias entre picos de intensidad
#  release 6: grabar datos curva estándar dinámica, pero no a gráfico luego en Excel
# Marzo 2024: Estandarización distancias
clearinfo
#
tipof$ ="txt"
# #############################
# Directorios con los ficheros se pide por pantalla
# #############################
form APH: estandarización dinámica y cálculo distancias (V2)
comment a) Directorio de los ficheros entrada (Intensidad y distancias- s/APH_Extraccion)
  text dirint 
comment b) Directorio de análisis dinámico (Curva Estándar) y distancias
  text dirce 
endform
# #########################################
Create Strings as file list... list 'dirint$'/*.*
numberOfFiles = Get number of strings
#
#
for ifile to numberOfFiles
  if ifile = 3
# echo valores 
# printline fichero entrada : 'fichero$'
# printline fichero salida : 'fichero_sal$'
# printline dirce : 'dirce$'
 endif
# ################
# Inicialización de variables
cabecera = 0
i = 0
j = 1
x = 0
distancia = 0
distancia_ant = 0
distancia2 = 0
distancia_treball = 0
int = 0
intant = 0
pico_intens = 0
perc = 0
percant = 0
ce = 0
ceant = 0
dist1ant = 0
dist1ce = 0
dist1porc= 0
dist1_ceant= 0
dist1porc_ant= 0
filas_ficheros = 0
#
  select Strings list
  fichero$ = Get string... ifile
  Read Table from comma-separated file... 'dirint$'\'fichero$'
  numberOfRows = Get number of rows
  filasiguiente = 'numberOfRows' + 1
  filasiguiente$ = fixed$ (filasiguiente, 0)
  call cabecera 'dirce$' 'fichero$' 
  call calculo_din 'tipof$' 'dirce$' 'dirint$' 'fichero$'
  call calculo1 'tipof$' 'dirce$' 'dirint$' 'fichero$'
  call calculo_distest 'tipof$' 'dirce$' 'dirint$' 'fichero$'
  call grabar 'dirce$' 'fichero$' 'silaba$' 'int$' 'perc$' 'ce$' 'distancia_treball$'
  cabecera=cabecera+1
endfor
# #################################
# Procedimiento estandarización dinámica (intensidad)
# Bucle de cáluclo de % y curva estándar de intensidad 
# ##################################
procedure calculo_din .tipof$ .dirce$ .dirint$ .fichero$
# 
#
   for i to numberOfRows
     silaba$ = Get value... i Sílaba
     int = Get value... i pico_intens
     int$ = fixed$(int, 0)
     perc = Get value... i Porc_Int
     perc$ = fixed$(perc, 1)
# ########################
     ce = Get value... i CE_Int
# ########################
     ce$ = fixed$(ce, 0)
          if i = 1
                 perc = 100
                 perc$ = fixed$ (perc, 1)
                 ce = 100
                 ce$ = fixed$(ce, 0)
                 Set numeric value... i Porc_Int 'perc$'
                 Set numeric value... i CE_Int 'ce$'
                 percant$ = fixed$ (perc, 1)
                 ceant$ = fixed$(ce, 0)
                 intant$ = fixed$(int, 0)
         else
                  perc = (('int$'/'intant$') * 100) - (100)
                  perc$ = fixed$ (perc, 0)
                  ce = ('perc$'*'ceant$'/100) + 'ceant$'
                  ce$ = fixed$ (ce, 0)
                  Set numeric value... i Porc_Int 'perc$'
                  Set numeric value... i CE_Int 'ce$'

                  percant$ = fixed$(perc, 1)
                  ceant$ = fixed$(ce, 0)
                  intant$ = fixed$(int, 0)
								
        endif
  endfor
# fichero_sal$ = selected$("Table") 
endproc
# #########################################
#  Obtención valor + 1
# ######################################

 procedure calculo1 .tipof$ .dirce$ .dirint$ .fichero$

          for j to numberOfRows 
           distancia2 = Get value... j Tiempo_pico
           distancia2$ = fixed$ (distancia2, 3)
              call calculo_dist 'tipof$' 'dirce$' 'dirint$' 'fichero$' 'distancia2$'
							
                 endfor
#
endproc
# #######################################################
# Bucle cálculo distancias
# #######################################################
procedure calculo_dist .tipof$ .dirce$ .dirint$ .fichero$
   for i to numberOfRows 
           distancia = Get value... i Tiempo_pico
           distancia$ = fixed$ (distancia, 3)
           distancia_treball = 'distancia2$' - 'distancia$'
           distancia_treball$ = fixed$ (distancia_treball, 3)
# ################################
echo valores 
printline distancia : 'distancia$'
printline distancia treball: 'distancia_treball$'
printline distancia 2: 'distancia2$'
printline directorio: 'dirce$'
printline fichero salida: 'fichero$'
printline tabla: 
printline j: 'j'
printline i: 'i'
# ###############################
          if j-i = 1
           Set numeric value... i  Dist_Picos 'distancia_treball$'
           distancia2$ = fixed$(distancia, 3)
          endif	
							
       endfor
    
endproc

# #################################
# Procedimiento estandarización distancias
# Bucle de cáluclo de % y datos estándar de duración 
# Marzo 2024
# ##################################
procedure calculo_distest .tipof$ .dirce$ .dirint$ .fichero$
# 
#
   for x to numberOfRows
     silaba$ = Get value... x Sílaba
     dist1 = Get value... x Dist_Picos
     dist1$ = fixed$(dist1, 3)
     dist1porc = Get value... x Porc_Dist
     dist1porc$ = fixed$(dist1porc, 1)
     dist1ce = Get value... x Dist_Est
     dist1ce$ = fixed$(dist1ce, 0)
          if x = 1
                 dist1porc = 100
                 dist1porc$ = fixed$ (dist1porc, 2)
                 dist1ce = 100
                 dist1ce$ = fixed$ (dist1ce, 0)

                 Set numeric value... x Porc_Dist 'dist1porc$'
                 Set numeric value... x Dist_Est 'dist1ce$'

                 dist1porc_ant$ = fixed$ (dist1porc, 1)
                 dist1_ceant$ = fixed$(dist1ce, 0)
                 dist1ant$ = fixed$(dist1, 3)
         else
                  dist1porc = (('dist1$'/'dist1ant$') * 100) - (100)
                  dist1porc$ = fixed$ (dist1porc, 1)

                  dist1ce = ('dist1porc$'*'dist1_ceant$'/100) + 'dist1_ceant$'
                  dist1ce$ = fixed$ (dist1ce, 0)

                  Set numeric value... x Porc_Dist 'dist1porc$'
                  Set numeric value... x Dist_Est 'dist1ce$'

                  dist1porc_ant$ = fixed$ (dist1porc, 1)
                  dist1_ceant$ = fixed$(dist1ce, 0)
                  dist1ant$ = fixed$(dist1, 3)
								
        endif
  endfor
# fichero_sal$ = selected$("Table") 
endproc

procedure cabecera .dirce$ .fichero$
deleteFile ("'dirce$'\'fichero$'")
deleteFile ("'dirce$'\'fichero$'.txt")
   fileappend "'dirce$'\'fichero$'"
                ... Silaba,Intensidad,Porcentaje,Ce_Int,Distancia,Porc_Dist,Distancia_Est'newline$' 
#               ... Silaba,Ce_Int,Distancia 'newline$'


endproc

procedure grabar .dirce$ .fichero$ .silaba$ .int$ .perc$ .ce$ .distancia_treball$
 fichero$ = selected$("Table")
 for i to numberOfRows
     silaba$ = Get value... i Sílaba
     int = Get value... i pico_intens
     int$ = fixed$ (int, 2)
     perc = Get value... i Porc_Int
     perc$ = fixed$ (perc, 1)
     ce = Get value... i CE_Int
     ce$ = fixed$(ce, 0)
     distancia_1 = Get value... i Dist_Picos
     distancia_2$ = fixed$ (distancia_1, 3)
     dist1porc = Get value... i Porc_Dist
     dist1porc$ = fixed$ (dist1porc, 1)
     dist1ce = Get value... i Dist_Est
     dist1ce$ = fixed$ (dist1ce, 0)
          
  if (silaba$ <> "Z" and silaba$ <> "z")
   fileappend "'dirce$'\'fichero$'.txt"
         ... 'silaba$','int$:2','perc$:0','ce$:0','distancia_2$:3', 'dist1porc$:1', 'dist1ce$:0' 'newline$'
  endif
 endfor
endproc
# ################################
# echo valores 
# printline directorio : 'dirce$'
# printline fichero: 'fichero$'
# ###############################

    
