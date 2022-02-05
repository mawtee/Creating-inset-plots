* Open log
************************
capture log close
log using "tibbles_inset_zipF/tibbles_inset.log" ,replace

* PLOT 1
*************************
webuse citytemp4, clear
separate(tempjuly), by(region)
label variable tempjuly1 "NE"
label variable tempjuly2 "N Cntrl"
label variable tempjuly3 "South"
label variable tempjuly4 "West"
set scheme sj
local mops msymbol(O D S T) msize(1.2 1.2 1.2 1.2) mfcolor(gs0 gs5 gs10 gs15) ///
mlcolor(gs0 gs0 gs0 gs0) mlwidth(.05 .05 .05 .05) 
local lops legend(order(0 "Region" 1 2 3 4) rows(1))
local labs xtitle("Cooling Degree Days (CDD)") ytitle("Average July temperature")
graph twoway scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd, `mops' `lops' `labs' name(p1, replace)
graph save p1 "tibbles_inset_zipF/tibbles_inset_fig1.eps", replace

* PLOT 2
*************************
local bops lpattern(solid) lwidth(thin) lcolor(black)
graph twoway scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd, ///
`mops' `lops' `labs' ///
|| scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd ///
if inrange(tempjuly, 70, 75) & cooldd <= 950, `mops' ///
yaxis(2) xaxis(2) ylabel(69 90, axis(2)) xlabel(-300 1100, axis(2)) ///
yscale(axis(2)off) xscale(axis(2)off) norescaling ///
|| scatteri 60 2100 72 2100 72 3950 60 3950 60 2100, recast(line) `bops' name(p2, replace)
graph save p2 "tibbles_inset_zipF/tibbles_inset_fig2.eps", replace

* PLOT 3
**************************                                         
forvalues r = 1/4 {
   twoway__histogram_gen cooldd if region ==`r',                                ///
   density gen(h`r' x`r') start(0) width(300)
}
replace x1 = x1 - 50
replace x2 = x2 - 100
replace x3 = x3 - 150
replace x4 = x4 - 200
local l2ops legend(order(0 "Region" 2 3 4 5) rows(1))
local dops lcolor(black) lwidth(vthin)
graph twoway scatteri 70 -250 72 -250 72 4300 70 4300 70 -250, recast(area)     ///
color(gs14%70) lpattern(solid)  lwidth(vthin) plotregion(margin(l =-2.1))       ///
|| scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd,`mops' `l2ops' `labs' ///
|| scatteri 70 380 72 380 72 959 70 959 70 380, recast(area) color(gs14%70)     ///
lpattern(solid) lwidth(vthin) yaxis(2) xaxis(2)  ylabel(69 90, axis(2))         ///
xlabel(-300 1100, axis(2)) yscale(axis(2)off) xscale(axis(2)off) norescaling    ///
|| scatteri 74.9 380 75.95 380 75.95 959 74.9 959 74.9 380, recast(area)        ///
yaxis(2) xaxis(2) color(white)  lpattern(solid) lwidth(vthin)                   ///
|| scatter tempjuly1 tempjuly2 tempjuly3 tempjuly4 cooldd                       ///
if inrange(tempjuly, 70, 75) & cooldd <= 950, `mops' `l2ops'  yaxis(2) xaxis(2) ///
|| scatteri 60 2000 72 2000 72 3925 60 3925 60 2000, recast(line) `bops'        ///
|| scatteri 70 500 76 500 76 950 70 950 70 500, recast(line) `bops'             ///
|| scatteri 70 500 60 2000, recast(line) `bops'                                 ///
|| scatteri 76 950 72 3925, recast(line) `bops'                                 ///
|| pci 71 371 71 380, xaxis(2) yaxis(2) `bops'                                  ///
text(71 350 "71", size(4.5pt) xaxis(2) yaxis(2) just(left))                     ///
|| pci 73 371 73 380, xaxis(2) yaxis(2) `bops'                                  ///
text(73 350 "73", size(4.5pt) xaxis(2) yaxis(2) just(left))                     ///
|| pci 75 371 75 380, xaxis(2) yaxis(2) `bops'                                  ///
text(75 350 "75", size(4.5pt) xaxis(2) yaxis(2) just(left))                     ///
|| pci 69.75 500 69.95 500, xaxis(2) yaxis(2) `bops'                            ///
text(69.25 500 "500", size(4.5pt) xaxis(2) yaxis(2) just(left))                 ///
|| pci 69.75 700 69.95 700, xaxis(2) yaxis(2) `bops'                            ///
text(69.25 700 "700", size(4.5pt) xaxis(2) yaxis(2) just(left))                 ///
|| pci 69.75 900 69.95 900, xaxis(2) yaxis(2) `bops'                            ///
text(69.25 900 "900", size(4.5pt) xaxis(2) yaxis(2) just(left))                 ///
|| bar h1 x1, barw(50) fcolor(gs0) `dops' yaxis(3) xaxis(3)                     ///
ylabel(0.0075 0.005, axis(3)) xlabel(0 4000, axis(3))                           ///
yscale(reverse axis(3) off)  xscale(alt axis(3) off)                            ///
|| bar h2 x2, barw(50) fcolor(gs5)  `dops'  yaxis(3)  xaxis(3)                  ///
|| bar h3 x3, barw(50) fcolor(gs10)  `dops' yaxis(3)  xaxis(3)                  ///
|| bar h4 x4, barw(50) fcolor(gs15)  `dops'  yaxis(3)  xaxis(3)                 ///
plotregion(margin(t = -1.95))                                                   ///                       
|| kdensity tempjuly if region == 1, recast(area) horizontal  fcolor(gs0%90)    ///
`dops'  yaxis(4) xaxis(4)   ylabel(60 100, axis(4)) xlabel(0 2, axis(4))        ///
 xscale(axis(4) reverse off)  yscale(axis(4) off)                               ///
|| kdensity tempjuly if region == 2, recast(area) horizontal  fcolor(gs5%90)    ///
`dops' yaxis(4)  xaxis(4)                                                       ///
|| kdensity tempjuly if region == 3, recast(area) horizontal fcolor(gs10%90)    ///
 lcolor(black) yaxis(4)  xaxis(4)                                               ///
|| kdensity tempjuly if region == 4, recast(area) horizontal  fcolor(gs15%90)   ///
lcolor(black) yaxis(4) xaxis(4) plotregion(margin(r =-1.95)) name(p3, replace)
graph save p3 "tibbles_inset_zipF/tibbles_inset_fig3.eps", replace

* Close log
*************************
log close
exit









