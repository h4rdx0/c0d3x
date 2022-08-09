# c0d3x

c0d3x is a simple UrlChecker that you can use to check the status code of some links.

You can use with these options:

 -f : Grep by status code
       Ex: c0d3x -f 200,301,302

 -t : Load a target list
       Ex: c0d3x -t targets.txt

 -o : Save the output (raw format)
       Ex: c0d3x -o output.txt

 -r : Raw output to use with another combined command on pipeline
       Ex: c0d3x -r | anothercommand

You also can combine all these parameters:
  Ex: c0d3x -f 200,301,302,403 -t targets.txt -o output.txt

This program could be used alone or combined with another command on pipeline:

Ex: gau https://google.com | grep "\.js$" | c0d3x -f 200


Hint: You can create a sLink into your /usr/bin folder.

    ln -s $folder/c0d3x/c0d3x.sh /usr/bin/c0d3x

    Now you can use c0d3x from anywhere!!
