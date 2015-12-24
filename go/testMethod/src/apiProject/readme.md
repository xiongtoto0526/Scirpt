#run with api docs:
## how to install
-  follow: http://beego.me/docs/advantage/docs.md
-  the last step skip the website , follow this:
   First time , will download the swagger and generate the doc
   
    <code>bee run -downdoc=true -gendoc=true</code>

      
   And every time after changing the doc related comment, you can do 
   
    <code>bee run --gendoc=true</code>

 ## how to run
 open in ie-explorer : http://localhost:8080/swagger/swagger-1/#!/object/create

