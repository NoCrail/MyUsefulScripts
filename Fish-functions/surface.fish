function surface --argument link --description="Create link shortcut on my SurfaceRT"
     echo "Creating link shortcut"
     set name $(echo $link | cut -c9-25 | awk 'BEGIN {FS="."}; {print $1}')
     echo $name
     echo -E "[{000214A0-0000-0000-C000-000000000046}]
Prop3=19,2
[InternetShortcut]
IDList=
URL=$link" > /Volumes/Shared/$name.url
     echo "Done"
end
      
