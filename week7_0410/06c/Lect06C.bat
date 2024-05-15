REM Original batch file was created by Ying-Ping Kuo (郭鶯萍) at Remote Sensing and Geodetic Lab, Department of Geosciences, NTU.
REM Batch file modified by Jyr-Ching Hu at Department of Geoscicences, National Taiwan University
REM Background seismicity and aftershocks of Meinong earthquake from Central Weather Bureau (CWB)

set prefix=Lect06C
gmt gmtset FORMAT_GEO_MAP ddd:mm:ssF
gmt gmtset FONT_LABEL 10p MAP_ANNOT_OFFSET_PRIMARY 0.075i MAP_LABEL_OFFSET 0.085i MAP_FRAME_WIDTH 0.045i MAP_TICK_LENGTH_PRIMARY 0.080i
gmt gmtset PS_CHAR_ENCODING Standard+

set grd1=C:/gridfiles/TW_20m_WGS84.nc
set grd2=tw_sw40.grd

echo x1=120.1，x2=120.8，y1=22.6，y2=23.2
set x1=120.100109867
set x2=120.799833826
set y1=22.5998854948
set y2=23.1999444835
set range=%x1%/%x2%/%y1%/%y2%

REM grdinfo %grd1% > TW_20m_WGS84.nc
REM type Taiwan40m_WGS84.info
gmt grdcut %grd1% -G%grd2% -R%range% -V
gmt makecpt -Cgray -T0/4000/500 -I -N > topo_gray.cpt
echo B	white >> topo_gray.cpt
echo F	black >> topo_gray.cpt
echo N	204 255 255 >> topo_gray.cpt
gmt begin %prefix% jpg A+m0.5c
gmt basemap -JM121/23/15c -R%range% -Bxa0.2f0.1 -Bya0.2f0.1 -BWeSn+t"Meinong earthquake, aftershocks and seismicity" ^
--FONT_TITLE=18p,16,blue --MAP_TITLE_OFFSET=2p -Y5c -V
gmt grdimage %grd2% -Ctopo_gray.cpt -I+a300-V
gmt makecpt -Cbathy -H  -T-40/0/10 -Z > fd_blue.cpt -V 
gmt makecpt -Cbathy -H  -T0/40/10 -Z -I > fd_blue+.cpt -V 
gmt makecpt -Chot -H  -T-40/0/10 -Z > fd_hot.cpt -V 
gmt makecpt -Chot -H -T0/40/10 -Z -I > fd_hot+.cpt -V 

echo background seismiity....
gawk "{if ($4 > 2) print $1, $2, -$3, $4}" CWAEQs_1995-2022.txt > EQs_1995-2022.gmt
gawk "{if ($4 >= 3 && $4 < 4) print $1, $2, $3, $4 }" EQs_1995-2022.gmt | gmt plot  -Sc0.2c -Cfd_blue+.cpt -W0.01 -V
gawk "{if ($4 >= 4 && $4 < 5) print $1, $2, $3, $4 }" EQs_1995-2022.gmt | gmt plot  -Sc0.3c -Cfd_blue+.cpt -W0.01 -V
gawk "{if ($4 >= 5 && $4 < 6) print $1, $2, $3, $4 }" EQs_1995-2022.gmt | gmt plot  -Sc0.4c -Cfd_blue+.cpt -W0.01 -V
gawk "{if ($4 >= 6 && $4 < 9) print $1, $2, $3, $4 }" EQs_1995-2022.gmt | gmt plot  -Sc0.5c -Cfd_blue+.cpt -W0.01 -V 

gawk "{if ($4 >= 2 && $4 < 3) print $1, $2, $3, $4 }" Meinong.txt | gmt plot  -Sa0.2c -Cfd_hot+.cpt -W0.01 -V
gawk "{if ($4 >= 3 && $4 < 4) print $1, $2, $3, $4 }" Meinong.txt | gmt plot  -Sa0.3c -Cfd_hot+.cpt -W0.01 -V
gawk "{if ($4 >= 4 && $4 < 5) print $1, $2, $3, $4 }" Meinong.txt | gmt plot  -Sa0.4c -Cfd_hot+.cpt -W0.01 -V
gawk "{if ($4 >= 5 && $4 < 6) print $1, $2, $3, $4 }" Meinong.txt | gmt plot  -Sa0.5c -Cfd_hot+.cpt -W0.01 -V
gawk "{if ($4 >= 6 && $4 < 9) print $1, $2, $3, $4 }" Meinong.txt | gmt plot  -Sa0.6c -Cfd_hot+.cpt -W0.01 -V

echo Active faults (CGS, 2010) and Lungchung fault
gmt plot ActiveFaults_CGS2010_WGS84.txt -W1.5p,black -V
gmt plot LCNF.txt -W1.5p,black,- -V

REM ======epicenters =====
echo 120.54 22.93 16 6.11 | gmt plot -Sa0.6c -Cfd_hot+.cpt -W0.01 -V
echo 120.25 22.96 29 3.63 | gmt plot -Sa0.3c -Cfd_hot+.cpt -W0.01 -V
echo 120.33	23.07 2 6.1 | gmt plot -Sc0.5c -Cfd_blue+.cpt -W0.01 -V
echo 120.73	23 5 6.4 | gmt plot -Sc0.5c -Cfd_blue+.cpt -W0.01 -V 
echo 120.78	22.74 15 5.4 | gmt plot -Sc0.4c -Cfd_blue+.cpt -W0.01 -V

REM ======= Plot Scale Text ====================
echo 120.20 22.55 3 50 | gmt plot -Sc0.2c -Cfd_blue+.cpt -W0.01 -V -N
echo 120.24 22.55 4 50 | gmt plot -Sc0.3c -Cfd_blue+.cpt -W0.01 -V -N
echo 120.28 22.55 5 50 | gmt plot -Sc0.4c -Cfd_blue+.cpt -W0.01 -V -N
echo 120.33 22.55 6 50 | gmt plot -Sc0.5c -Cfd_blue+.cpt -W0.01 -V -N

echo 120.16 22.515 2 | gmt plot -Sa0.2c -Cfd_hot+.cpt -W0.01 -V -N
echo 120.20 22.515 3 | gmt plot -Sa0.3c -Cfd_hot+.cpt -W0.01 -V -N
echo 120.24 22.515 4 | gmt plot -Sa0.4c -Cfd_hot+.cpt -W0.01 -V -N
echo 120.28 22.515 5 | gmt plot -Sa0.5c -Cfd_hot+.cpt -W0.01 -V -N
echo 120.33 22.515 6 | gmt plot -Sa0.6c -Cfd_hot+.cpt -W0.01 -V -N

echo 120.1 22.48 M@-L@- | gmt text -F+f14p,Helvetica+jCM -V -N
echo 120.13 22.48 = | gmt text -F+f14p,Helvetica+jCM -V -N
echo 120.16 22.48 2 | gmt text -F+f14p,Helvetica+jCM -V -N
echo 120.20 22.48 3 | gmt text -F+f14p,Helvetica+jCM -V -N
echo 120.24 22.48 4 | gmt text -F+f14p,Helvetica+jCM -V -N
echo 120.28 22.48 5 | gmt text -F+f14p,Helvetica+jCM -V -N
echo 120.33 22.48 6@~\255@~ | gmt text -F+f14p,Helvetica+jCM -V -N

rem ======= Plot focal mechanisms of main shock and aftershock ====================
echo 120.54	22.93 16 288.36 51.02 19.79 6.11 120.85 22.9 2016/2/6 | gmt meca -Sa1c+f10p+o3p -Fa4p/cc -Cfd_hot+.cpt -A -L -N -V
echo 120.25	22.96 29 268.64	20.08 -16.68 3.63 120.05 22.85	2016/2/19 | gmt meca -Sa1c+f10p+o3p -Fa4p/cc -Cfd_hot+.cpt -A -L -N -V
rem ======= Plot focal mechanisms of historic events ====================
echo 120.33	23.07 2 75 90 -151 6.1 120.05 23.1 1946/12/4 | gmt meca -Sa1c+f10p+o3p -Fa4p/cc -Cfd_blue+.cpt -A -L -N -V
echo 120.73	23 5 318.05	41.39 67.64	6.4	120.85 23.1 2010/3/4 | gmt meca -Sa1c+f10p+o3p -Fa4p/cc -Cfd_blue+.cpt -A -L -N -V
echo 120.78	22.74 15 161.12	36.65 114.09 5.4 120.85 22.7 2012/2/26 | gmt meca -Sa1c+f10p+o3p -Fa4p/cc -Cfd_blue+.cpt -A -L -N -V

gmt colorbar -Ctopo_gray.cpt -Dx10.5c/-1.7c+w4.5c/0.3c+h -V -Bxa1000f500+l"Elevation" -By+l"m"
gmt colorbar -C"fd_blue+.cpt" -Dx5.5c/-1.3c+w4.5c/0.3c+h -V -B0 -Bf5
gmt colorbar -C"fd_hot+.cpt" -Dx5.5c/-2.1c+w4.5c/0.3c+h -V -Bxa10f5+l"Focal Depth (km)"

gmt end

del  *.conf *.grd *.history

pause








