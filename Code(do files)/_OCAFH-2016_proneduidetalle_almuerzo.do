** tareas pendientes
* hacer un cálculo de los promedios calóricos y nutricionales por almuerzo
	* desagregar promedio calórico del almuerzo por departamento
	* desagregar promedio calórico del almuerzo por tipo de comercio
	* desagregar promedio calórico por tipo de alimento (?)
* calcular promedio de precio de almuerzo por departamento
* calcular calorías compradas por el precio de un boliviano
	* en qué departamento se compran más calorías por un boliviano
	* en qué tipo de comercio se compra más calorías por un boliviano
	
* Primero calcular el costo del almuerzo
clear all
set more off

/* SETTING PRIMARY GLOBALS */

global path "C:\Users\Vladimir\Desktop\_hivos"
global in "$path/_raw(dta)/"
global out "$path/_output/"
global temp "$path/_temp/"
global log "$path/_log/"
global do "$path/_functions(do)/"

********************************************************************************
/*SETTING OTHER GLOBALS*/
global year 2015
global country "Bolivia"

********************************************************************************
/* IMPORTING DATA */
use "$in/OCAFH-2016_promediodetalle_almuerzo.dta"

********************************************************************************
/* FILTERING DATA */
			
			************************************************
			************************************************
			************************************************
			************************************************

					/*--- MAIN CODE STARTS HERE ---*/
* YEAR
capture drop year
gen year ="$year"

* COUNTRY
capture drop country
gen country="$country"
					
* FOLIO /*un folio equivale a una muestra de almuerzo*/
rename folios folio

* DEPARTAMENTO
capture drop idep
rename dept idep

* LUGAR /* lugar donde alimento fue comprado */
capture drop ilugar
rename lugar_compra ilugar

* ID PREPARACION /* ID plato de comida */
capture drop iprep
labmask id_preparacion, values(preparacion) //<- para asignar valores de preparación como etiquetas de id_preparacion
rename id_preparacion iprep

* ID TIEMPO COMIDA /* desayuno, almuerzo o cena -- todos son almuerzos*/
capture drop icomida
rename tiempo_comida icomida

*********************************************************************************				
				* TOTAL VALOR NUTRICIONAL POR ALMUERZO *
				////////////////////////////////////////
					
* calcular peso total por almuerzo
capture drop _alpeso
egen _alpeso = sum(peso), by(folio)

* costo total por almuerzo
capture drop _alcosto
egen _alcosto = sum(costo), by(folio)

* energia total por almuerzo
capture drop _alenerg
egen _alenerg = sum(energia), by(folio)

* humedad total por almuerzo
capture drop _alhumed
egen _alhumed = sum(humedad), by(folio)

* proteina total por almuerzo
capture drop _algrasa
egen _algrasa = sum(grasa), by(folio)

* cho total por almuerzo (hidratos de carbono)
capture drop _alcho
egen _alcho = sum(cho), by(folio)

* f_cruda por almuerzo 
capture drop _alfcruda
egen _alfcruda = sum(f_cruda), by(folio)

* calcio total por almuerzo
capture drop _alcalcio
egen _alcalcio = sum(ca), by(folio)

* potasio total 
capture drop _alpot
egen _alpot = sum(p), by(folio)

* hierro total
capture drop _alhier
egen _alhier = sum(fe), by(folio)

* vitamina a total
capture drop _alvita
egen _alvita = sum(vitamina_a),by(folio)

* tiamina total
capture drop _alvitb1
egen _alvitb1= sum(tiamina), by(folio)

* riboflavina total
capture drop _alribo
egen _alribo = sum(riboflav), by(folio)

* niacina total
capture drop _alniaci
egen _alniaci = sum(niacina), by(folio)

* vitamin c total
capture drop _alvitc
egen _alvitc =  sum(vitaminac), by(folio)

********************************************************************************

* promedio costo de almuerzo por departamento
	foreach dep of numlist 1/9{
	capture drop _depcosto`dep'
	egen _depcosto`dep' = mean(_alcosto) if idep == `dep'
	}
	
* promedio costo de almuerzo por lugar de compra a nivel nacional
	foreach lug of numlist 1/4{
	capture drop _lugcosto`lug'
	egen _lugcosto`lug' = mean(_alcosto) if ilugar==`lug'
	}
	
* promedio costo de almuerzo por departamento y lugar de compra
	foreach dep of numlist 1/9{
	foreach lug of numlist 1/4{
	capture drop _lugdepcost`dep'_`lug'
	egen _lugdepcost`dep'_`lug' = mean(_alcosto) if idep==`dep' & ilugar == `lug'
	}}
	
* promedio calorías por almuerzo en cada departamento 
	
	
* PROMEDIO CALORIAS ALMUERZO POR DEPARTAMENTO Y LUGAR DE COMPRA
	capture drop _alenerg_dep_lugar
	egen _alenerg_dep_lugar = mean(_alenerg) if idep==1 & ilug==1

	capture drop _depcosto1 //<- chuquisaca
	egen _depcosto1 = mean(_alcosto) if idep == 1
	
	capture drop _depcosto
	egen _depcosto = mean(_alcosto), by(idep)

* promedio costo por lugar de compra
	capture drop  _lugcosto
	egen _lugcosto = mean(_alcosto), by(ilugar)
	
* caloria promedio de un almuerzo por lugar en donde se compro
	