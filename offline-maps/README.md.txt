run the following command to start the docker and serve the map
change path of the sahred folder where map is hosted

docker run --rm -it -v C:/Users/i_fla/Desktop/OSM_UAE/tileserver-data:/data -p 8080:80 maptiler/tileserver-gl