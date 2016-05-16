reference:
http://hayageek.com/ios-long-running-background-task/

usage:
do a long running task for-ever in ios app.

note:

- set your info.plist,by the following key:
  Required background modes:
  item0:App plays audio or streams audio/video using AirPlay
  item1:App provides Voice over IP services

- run a task:
   [bgTask startBackgroundTasks:2 target:self selector:@selector(backgroundCallback:)];
   
   