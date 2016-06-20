#==================================================
# clear memory
#==================================================
rm(list = ls())

#==================================================
# load libaries
#==================================================
library(sp)
library(raster)

#==================================================
# code
#==================================================
# read NUT3-level polygons of Germany
ger_shape <- getData('GADM', country="DEU", level=3)

# select random points in Germany
random_points <- coordinates(spsample(ger_shape, 20, type='random'))

# convert the coodinates of random points to a SpatialPointsDataFrame
p <- SpatialPointsDataFrame(na.omit(random_points), 
                            data.frame(id=1:nrow(na.omit(random_points))),
                            proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# overlay points and polygons
pt <- over(p, ger_shape)

# select random points within the polygons
new <- do.call(rbind, lapply(1:nrow(pt), function(y) spsample(ger_shape[c(pt[y, 1]), ], 1, "random")))

# checking results
plot(ger_shape[pt[1,1], ])
points(p[1, ], col = "blue")
points(new[1, ], col = "red")