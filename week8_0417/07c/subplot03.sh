gmt begin subplot03 jpg A+m0.5c
gmt get FONT_TAG
gmt text -L
gmt set FONT_TAG 15p,Times-Roman
gmt subplot begin 2x2 -Fs4.0i/4.0i -A'(a)'+jTL+o0.2c/0.4c -M0.5c/0.2c -R-20/20/-20/20
gmt basemap -Ba -BWSen -c
gmt basemap -Ba -BWSen -c
gmt basemap -Ba -BWSen -c
# 下面的 gmt plot命令未使用-c 選項，但依然在第2行第1列子圖中繪製
echo 0 0 | gmt plot -Sa1c -Gred -W1p
gmt basemap -Ba -BWSen -c
gmt subplot end
gmt end