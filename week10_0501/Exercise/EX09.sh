# set variables
prefix=EX09
range=119.0/122.5/21.5/25.5
# configure
gmt set PROJ_LENGTH_UNIT = inch
gmt set FORMAT_GEO_MAP ddd:mm:ssF
gmt set FONT_LABEL 10p MAP_ANNOT_OFFSET_PRIMARY 0.075i MAP_LABEL_OFFSET 0.085i MAP_FRAME_WIDTH 0.045i MAP_TICK_LENGTH_PRIMARY 0.080i
gmt set PS_CHAR_ENCODING Standard+
gmt set FONT_TITLE 18p,16,blue MAP_TITLE_OFFSET 2p

grd1=Taiwan40m_WGS84.nc
grd2=Taidp200m.nc
gmt grdcut $grd1 -G$grd2 -R$range -V
# data processing
awk '{print $2, $3, $4, $6, $5, $7, 0, $1}' table.dat > table.gmt
awk '{print $1, $2, sqrt($3^2+$4^2)}' table.gmt > table_Vect.gmt
# make cpt for gps velo
gmt makecpt -Crainbow -T0/68 > cgps.cpt
# gmt plot
gmt begin $prefix png A+m0.5c
    # create basemap
    gmt grdimage $grd2 -CGray  -I+d -V
    gmt grdimage $grd1 -CGray -I+d -V
    gmt coast -R$range -JM121.0/6i -Df -W1.p,0/0/0 -Bxa1f0.5 -Bya1f0.5 -BWeSn+t"R12224203" -V
	# Plot Velocity gradientwith blockmean and surface
    gmt blockmean table_Vect.gmt -R$range -I0.01 -h1 > cgps_mean.xy
    gmt surface cgps_mean.xy -R$range -T0.35 -I0.01 -Gcgps_mean.xy.grd -V
    gmt grdimage cgps_mean.xy.grd -I+a315+ne0.3 -Ccgps.cpt -V
    gmt coast -Df -W1.5p -V -Sfloralwhite
    # Plot Basement High
    # gmt plot basement_high.txt -W1.0p,150/80/0,- -V
    gmt plot point.txt -W1.0p,150/80/0,- -V
    # Plot GPS vector and stations
    gmt velo table.dat -Se.015/0.95/0 -A0.15i+a30+e -W1.5p,Black -h1 -V
    
    # Plot active faults 
    fault11=../../week9_0424/Exercises/08a/Category_I_WGS84.gmt
    fault12=../../week9_0424/Exercises/08a/Category_I_concealed_WGS84.gmt
    fault21=../../week9_0424/Exercises/08a/Category_II_WGS84.gmt
    fault22=../../week9_0424/Exercises/08a/Category_II_concealed_WGS84.gmt
    gmt plot $fault11 -W0.5p,black -V
    gmt plot $fault12 -W0.5p,black,- -V
    gmt plot $fault21 -W0.5p,black -V
    gmt plot $fault22 -W0.5p,black,- -v

    # Add plates
    echo 119.50 24.00 Eurasian Plate | gmt text -F+f14p,Palatino-BoldItalic+jCM -V
    echo 121.80 22.80 Philippine Sea Plate | gmt text -F+f14p,Palatino-BoldItalic+jCM -V
    echo 119.59 23.65 -50 0 2 2 0 | gmt plot -Ss0.08 -W0.5p,0 -G255/0/0 -V
    echo 119.40 23.70 S01R | gmt text -F+f10p,Helvetica+jCM -V
    # Plot legend
    echo 121.60 21.70 -50 0 2 2 0 | gmt velo -Se.015/0.95/10 -A0.15i+a30+e -W1.5p,black
    echo 121.92 21.70 10,0 0 MC 50 \234 2 mm/yr | gmt text -F+f+a+j -V
    gmt colorbar -Ccgps.cpt -Dx4c/1.2c+w5c/0.2c+h+e+jCM -Ba10f5 -By+l"mm/yr" -I -V
    #  === inlet and locality map ===================================================================
    gmt set MAP_FRAME_WIDTH=0.001i MAP_TICK_LENGTH=0.000i
    gmt basemap -Bxa10f5 -Bya10f5 -Bwesn -JM121.0/1.5i -R110/135/15/36 -p180/90 -V -Y6.05 -X0.01
    echo 119.0 21.6 >  locality
    echo 119.0 25.5 >> locality
    echo 122.5 25.5 >> locality
    echo 122.5 21.6 >> locality
    gmt coast -Dh -W0.5p -Gpalegreen -Sivory -V
    gmt plot locality -L -W1p,black -N -V
gmt end
rm *.conf