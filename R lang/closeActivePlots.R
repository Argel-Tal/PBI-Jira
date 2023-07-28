# from: https://stackoverflow.com/questions/24207960/too-many-open-devices-r
# get list of all open devices
dev.list()
# close all open devices
for (i in dev.list()[1]:dev.list()[length(dev.list())]) {
   dev.off()
}
