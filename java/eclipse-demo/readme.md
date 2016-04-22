You want init a eclipse project by command with the source code ? follow me:

1. download the the src dir .
2. in terminal, use : gradle init .
3. open your build.gradle(generated above),edit (add what you want for you proj),save. 
4. open you gradle.setting (modify your proj-name),save.
5. in terminal, use : gradle build. 
6. in terminal, use : gradle clean eclipse.
7. import the project 
   - open eclipse
   - import -> general -> exist project ->locate the project dir-> ok
8. enjoy.