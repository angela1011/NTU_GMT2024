REM 2019 Ridge Earthquake ST-1 IFG
REM Orginal batch file from Bao-Han Tsao
REM set variables
set prefix=Lect07D1
set grd=C:\gridfiles\GEBCO_2023_sub_ice_topo.nc
set InSAR=phasefilt_ll.nc
set topo=temp.grd
set seis=2019RQ_seq.csv
set cmt=2019RQ_CMT.txt
set cpt1=topo_gray.cpt
set cpt2=phase.cpt
gmt set FORMAT_DATE_IN yyyy/mm/dd

REM Cut a region based on InSAR
gmt grdcut %grd% -R%InSAR% -G%topo%
REM create cpt for DEM　InSAR
gmt makecpt -Cgray -T0/4000/500 -I -N > %cpt1% -V
gmt makecpt -Cjet -T-3.14/3.14 -Ww > %cpt2% -V

gmt begin %prefix% jpg A+m0.5c
    REM create basemap
    gmt basemap -R%InSAR% -JM242.0/12.0i -Bxa1f0.5 -Bya1f0.5 -BWESN+t"2019 M@-w@- 7.1 Ridgecrest Earthquake" --FORMAT_GEO_MAP=ddd:mm:ssF -V
	REM create topography
	gmt grdimage %topo% -C%cpt1% -I+a45+ne1.0 -V
	REM draping interferogram with transparency
	gmt grdimage %InSAR%  -C%cpt2% -t30 -V
	REM colorbar
	gmt colorbar -C%cpt2% -Dx6.0i/-1.0i+jCM+w12.0i/0.25i+h -Bx1.57f1.57+lPhase -By+lrad -V
	REM plot earthquake sequence
	gawk "{if ($5 > 2.0 && $5 < 3.0) print $3, $2 }" FS="," %seis% | gmt plot -Sc6p -W0.25p,black -G0/255/255 -l"M@-L@- > 2.0"+s6p -V
	gawk "{if ($5 > 3.0 && $5 < 4.0) print $3, $2 }" FS="," %seis% | gmt plot -Sc8p -W0.25p,black -G0/255/255 -l"M@-L@- > 3.0"+s8p -V
	gawk "{if ($5 > 4.0 && $5 < 5.0) print $3, $2 }" FS="," %seis% | gmt plot -Sc10p -W0.25p,black -G0/255/255 -l"M@-L@- > 4.0"+s10p -V
	gawk "{if ($5 > 5.0 && $5 < 6.0) print $3, $2 }" FS="," %seis% | gmt plot -Sc12p -W0.25p,black -G0/255/255 -l"M@-L@- > 5.0"+s12p -V
	gawk "{if ($5 > 6.0 && $5 < 7.0) print $3, $2 }" FS="," %seis% | gmt plot -Sa14p -W0.25p,black -G255/255/0 -l"M@-L@- > 6.0"+s14p -V
	gawk "{if ($5 > 7.0) print $3, $2 }" FS="," %seis% | gmt plot -Sa16p -W0.25p,black -G255/0/0 -l"M@-w@- 7.1 Ridgecrest earthquake"+s16p -V
	REM plot focal mechanisms bsed on CMT of 2019 earthquake
	gmt meca %cmt% -Sa40p -W0.25p,black -Gred -A -V
	REM create legend
    gmt legend -Dx13.0i/10.0i+jTL -F+pthick+ithinner+gwhite --FONT_ANNOT_PRIMARY=16p,Times-Italic -V
	REM create basemap for time-mag. plot
	gmt basemap -JX8.0i/8.0i -R2019-07-01/2019-07-31/2.0/7.5 -Bxa8Df2D+lDate -Bya1.0f0.5+l"M@-L@-" -BWStr -X13.0i -V --FORMAT_DATE_MAP="o dd"
	REM plot time-mag. plot of earthquake sequence
    gawk "{if ($5 > 2.0 && $5 < 3.0) print $1, $5}" FS="," %seis%  | gmt plot -Sc6p -G0/255/255 -W0.25p,black -V
	gawk "{if ($5 > 3.0 && $5 < 4.0) print $1, $5}" FS="," %seis%  | gmt plot -Sc8p -G0/255/255 -W0.25p,black -V
	gawk "{if ($5 > 4.0 && $5 < 5.0) print $1, $5}" FS="," %seis%  | gmt plot -Sc10p -G0/255/255 -W0.25p,black -V
	gawk "{if ($5 > 5.0 && $5 < 6.0) print $1, $5}" FS="," %seis%  | gmt plot -Sc12p -G0/255/255 -W0.25p,black -V
	gawk "{if ($5 > 6.0 && $5 < 7.0) print $1, $5}" FS="," %seis%  | gmt plot -Sa14p -G255/255/0 -W0.25p,black -V
	gawk "{if ($5 > 7.0) print $1, $5}" FS="," %seis% | gmt plot -Sa16p -G255/0/0 -W0.25p,black -V
gmt end

del *.conf *.history phase.cpt 
pause