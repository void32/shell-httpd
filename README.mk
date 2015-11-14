This explains how to create a http server as a HTTP Deamon using the shell.

  ****************************************************************************
  ** WARNING THIS IS NOT A SAFE OR RECOMMENDED  WAY TO CREATE A HTTP SERVER **
  **                                                                        **
  ** THIS DOCUMENT IS SIMPLY A TUTORIAL FOR AN EXERCISE IN SHELL SCRIPTING  **
  ** AND SOCKETS.                                                           **
  ****************************************************************************

1.  Set up the TCP socket connection 

1.1 Create a socket listening for an incoming connection on a given port
    $ socat tcp-listen:<port> exec:<shell commando to run>
    
    example: 
        $ socat tcp-listen:8085 exec:'echo "hello world"'
 
Now we can execute the shell commando by accessing our computer on the 
    specified port. 
    For example if we open the browser on the same computer and type
    "localhost:8085" in the url-field.
    
    As an alternative to the browser, we can use a terminal and fx 
    socat, netcat, or telnet:
        $ socat tcp:localhost:8081 -
        or
        $ nc localhost 8085
        or
        $ telnet localhost 8085


1.2 The above only work for a single TCP connection, the os will lock for other 
connection on the samme port for some time. To avoid this we can use the 
'reuseaddr' and 'fork':
     $ socat tcp-listen:8085,reuseaddr,fork exec:'echo "hello world"'

Again we can test this with the bowser or a terminal using socat, netcat, or 
telnet.
    Example:
        $ while sleep 0.5; do socat tcp:localhost:8085 -; done



2. Scripts

2.1 Webserver start script - start_webserver
To start our webserver, we will use the following script. Since we now can 
reuse the selected port, we'll go ahead and use port 8080.
--------------------------------------------------------------------------------
#!/bin/bash
PORT=8080
CMD="my_http_deamon"
socat -v tcp-listen:$PORT,reuseaddr,fork exec:CMD
--------------------------------------------------------------------------------

2.2 Webserver scriptet - my_http_deamon
As we can see from the above script, our http server is script or program called 'my_http_deamon'.
--------------------------------------------------------------------------------
#!/bin/bash

# Send HTTP header berfore the actual data
echo HTTP/1.0 200 OK
echo

# HTML start tags
echo '<html>'
echo '<head>'
# Here you put the html head stuff you what on your page...

echo '</head>'


echo '<body>'
# Here you put the html body stuff you what on your page...

# For example - interpret the user request and generate web page from that:
read request
option=$(echo "$request" | cut -d ' ' -f 2)
case "$option" in
    (/knockknock )
        echo "Who's There?"
        ;;
    (/date )
        date
        ;;
    (/calc\?*)
        echo "${option##*\?}" | bc -l
        ;;
esac

# HTML end tags
echo '</body>'
echo '</html>'
--------------------------------------------------------------------------------


Now we can use the http web server through our browser:
    http://localhost:8080/knockknock
    http://localhost:8080/date
    http://localhost:8080/calc?-1+5






