* Open log
************************
clear all
capture log close
log using "tibbles_melse_inset_zipF/tibbles_melse_inset.log" ,replace

* PLOT 1
*************************
webuse citytemp4, clear
set scheme sj
separate(tempjuly), by(region)
label variable tempjuly1 "NE"
label variable tempjuly2 "N Cntrl"
label variable tempjuly3 "South"
label variable tempjuly4 "West"
local mops msymbol(O D S T) msize(1.2 1.2 1.2 1.2) mfcolor(gs0 gs5 gs10 gs15)    ///
mlcolor(gs0 gs0 gs0 gs0)  mlwidth(.05 .05 .05 .05) 
local lops legend(order(0 "Region" 1 2 3 4) rows(1))
local labs xtitle("Cooling Degree Days (CDD)") ytitle("Average July temperature")
scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd, `mops' `lops' `labs' name(p1, replace)
graph export tibbles_melse_inset_zipF/tibbles_melse_inset_fig1.eps, name(p1) replace

* PLOT 2
*************************
local iops xlab(,labsize(2)) ylab(,labsize(2)) ytitle("") xtitle("")            
scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd                          ///
if inrange(tempjuly, 70, 75) & cooldd <= 950, `mops' `labs' `iops' legend(off)  ///
fysize(20) fxsize(40)  graphregion(color(white) margin(0)) name(inset)     
graph combine p1 inset, holes(2) imargin(0 0 0 0) name(grc)
_gm_edit .grc.plotregion1.move graph2 rightof 1 1
_gm_edit .grc.plotregion1.graph2.DragBy 40 -45
graph display grc
graph export tibbles_melse_inset_zipF/tibbles_melse_inset_fig2.eps, name(grc) replace

* PLOT 3
*************************
_gm_edit .grc.plotregion1.Expand graph1 right 1 
_gm_edit .grc.plotregion1.Expand graph1 bottom 1 
_gm_edit .grc.plotregion1.graph2.DragBy -5 85
graph display grc
graph export tibbles_melse_inset_zipF/tibbles_melse_inset_fig3.eps, name(grc) replace

* PLOT 4
*************************
local bops lpattern(solid) lwidth(thin) lcolor(black)
graph twoway scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd, ///
`mops' `lops' `labs' ///
|| scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd ///
if inrange(tempjuly, 70, 75) & cooldd <= 950, `mops' ///
yaxis(2) xaxis(2) ylabel(69 90, axis(2)) xlabel(-300 1100, axis(2)) ///
yscale(axis(2)off) xscale(axis(2)off) norescaling ///
|| scatteri 60 2100 72 2100 72 3950 60 3950 60 2100, recast(line) `bops' name(p4, replace)
graph export tibbles_melse_inset_zipF/tibbles_melse_inset_fig4.eps, name(p4) replace

* PLOT 5
**************************                                         
forvalues r = 1/4 {
   twoway__histogram_gen cooldd if region ==`r',                                ///
   density gen(h`r' x`r') start(0) width(300)
}
replace x1 = x1 - 300
replace x2 = x2 - 350
replace x3 = x3 - 400
replace x4 = x4 - 450
local l2ops legend(order(0 "Region" 2 3 4 5) rows(1))
local dops lcolor(black) lwidth(vthin)
graph twoway scatteri 70 -50 72 -50 72 4700 70 4700 70 -50, recast(area)        ///
color(gs14%70) lpattern(solid)  lwidth(vthin) plotregion(margin(l = -2.75))     ///
|| scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd,`mops' `l2ops' `labs' ///
xlab(0 1000 2000 3000 4000) xscale(range(-150 4750))                            ///
|| scatteri 70 373 72 373 72 971.2 70 971.2 70 373, recast(area) color(gs14%70) ///
lpattern(solid) lwidth(vthin) yaxis(2) xaxis(2)  ylabel(69 90, axis(2))         ///
xlabel(-300 1150, axis(2)) yscale(axis(2)off) xscale(axis(2)off) norescaling    ///
|| scatteri 74.9 373 75.93 373 75.93 971.23 74.9 971.3 74.9 373, recast(area)   ///
yaxis(2) xaxis(2) color(white)  lpattern(solid) lwidth(vthin)                   ///
|| scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd                       ///
if inrange(tempjuly, 70, 75) & cooldd <= 950, `mops' `l2ops'  yaxis(2) xaxis(2) ///
|| scatteri 60 2120 72 2120 72 4150 60 4150 60 2120, recast(line) `bops'        ///
|| scatteri 70 500 76 500 76 950 70 950 70 500, recast(line) `bops'             ///
|| scatteri 70 500 60 2120, recast(line) `bops'                                 ///
|| scatteri 76 950 72 4150, recast(line) `bops'                                 ///
|| pci 71 364 71 372, xaxis(2) yaxis(2) `bops'                                  ///
text(71 344 "71", size(4.5pt) xaxis(2) yaxis(2) just(left))                     ///
|| pci 73 364 73 372, xaxis(2) yaxis(2) `bops'                                  ///
text(73 344 "73", size(4.5pt) xaxis(2) yaxis(2) just(left))                     ///
|| pci 75 364 75 372, xaxis(2) yaxis(2) `bops'                                  ///
text(75 344 "75", size(4.5pt) xaxis(2) yaxis(2) just(left))                     ///
|| pci 69.75 500 69.95 500, xaxis(2) yaxis(2) `bops'                            ///
text(69.25 500 "500", size(4.5pt) xaxis(2) yaxis(2) just(left))                 ///
|| pci 69.75 700 69.95 700, xaxis(2) yaxis(2) `bops'                            ///
text(69.25 700 "700", size(4.5pt) xaxis(2) yaxis(2) just(left))                 ///
|| pci 69.75 900 69.95 900, xaxis(2) yaxis(2) `bops'                            ///
text(69.25 900 "900", size(4.5pt) xaxis(2) yaxis(2) just(left))                 ///
|| bar h1 x1, barw(50) fcolor(gs0) `dops' yaxis(3) xaxis(3)                     ///
ylabel(0.0075 0.005, axis(3)) xlabel(-300 4750, axis(3))                        ///
yscale(reverse axis(3) off)  xscale(alt axis(3) range(-400 4750)off)            ///
|| bar h2 x2, barw(50) fcolor(gs5) `dops'  yaxis(3)  xaxis(3)                   ///
|| bar h3 x3, barw(50) fcolor(gs10) `dops' yaxis(3)  xaxis(3)                   ///
|| bar h4 x4, barw(50) fcolor(gs15) `dops' yaxis(3)  xaxis(3)                   ///
plotregion(margin(t = -2.2))                                                    ///                       
|| kdensity tempjuly if region == 1, recast(area) horizontal  fcolor(gs0%90)    ///
`dops'  yaxis(4) xaxis(4)   ylabel(60 100, axis(4)) xlabel(0 2, axis(4))        ///
 xscale(axis(4) reverse off)  yscale(axis(4) off)                               ///
|| kdensity tempjuly if region == 2, recast(area) horizontal  fcolor(gs5%90)    ///
`dops' yaxis(4)  xaxis(4)                                                       ///
|| kdensity tempjuly if region == 3, recast(area) horizontal fcolor(gs10%90)    ///
 lcolor(black) yaxis(4) xaxis(4)                                                ///
|| kdensity tempjuly if region == 4, recast(area) horizontal  fcolor(gs15%90)   ///
lcolor(black) yaxis(4) xaxis(4) plotregion(margin(r =-1.95 l =-2.2)) name(p5, replace)
graph export tibbles_melse_inset_zipF/tibbles_melse_inset_fig5.eps, name(p5) replace

* Close log
*************************
log close
exit









