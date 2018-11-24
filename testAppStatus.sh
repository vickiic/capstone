#!/bin/bash
STR= gcloud app describe | grep servingStatus:
echo $STR
echo "servingStatus: SERVING"
if [ "$STR" = "servingStatus: SERVING" ]
then
    echo "The service is running"
else
    echo "The service is NOT running correctly. \n Please run 'gcloud app describe' for more info"
fi
