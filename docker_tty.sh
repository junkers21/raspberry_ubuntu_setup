#!/bin/bash
                                                           
echo "Usb event: $1 $2 $3 $4" >> /tmp/docker_tty.log        
if [ ! -z "$(docker ps -qf name=gcode-web-1)" ]                                     
then                                                                            
if [ "$1" == "added" ]                                                          
    then                                                                        
        docker exec -u 0 gcode-web-1 mknod $2 c $3 $4                               
        docker exec -u 0 gcode-web-1 chmod -R 777 $2                                
        echo "Adding $2 to docker" >> /tmp/docker_tty.log                
    else                                                                        
        docker exec -u 0 gcode-web-1 rm $2                                          
        echo "Removing $2 from docker" >> /tmp/docker_tty.log            
    fi                                                                          
fi 