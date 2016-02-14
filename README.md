# Lonline for Ruby
Lonline allows you to log your program's execution into the cloud to avoid server access and disk space usage.

Lonline provides 6 levels of logging and 2 methods to execute reports.  Lonline is a gem to log your program through a storing service called Dynamicloud.  With Dynamicloud we can store data dynamically and very easy, Lonline allows you to set more features and this way log more than only text, level and program trace.

**This documentation has the following content:**

1. [Dependencies](#dependencies)
  1. [Dynamicloud](#dynamicloud) 
2. [Levels](#levels)
3. [Settings](#settings)
4. [Ruby generator](#ruby-generator)
5. [How to use](#how-to-use)
 
#Dependencies
**Lonline has two main depedendencies:** Json gem and Dynamicloud gem, so when you're installing lonline gem those dependencies will be installed in your system.

#Dynamicloud
Dynamicloud is a service to store data into the cloud, it allows you to create structures dynamically without intervention from IT teams.  This service allows lonline to store log information very easy and fast.  Additionally, lonline gets the power of Dynamicloud to execute queries and provide reports for your analisis about created log in a specific time, date, year, etc.

For further information about Dynamicloud visit its site [Dynamicloud](http://www.dynamicloud.org/ "Dynamicloud").

#Levels
Lonline provides 6 levels of logging, check out the below table to understand how these levels are activated according the level of logging in your program:

| Level | Activated levels | Description |
| --- | --- | --- |
| `fatal` | Fatal | Designates very severe error events that will presumably lead the application to abort.|
| `error` | Fatal, Error | Designates error events that might still allow the application to continue running.|
| `warn` | Fatal, Error, Warn | Designates potentially harmful situations.|
| `info` | Fatal, Error, Warn, Info | Designates informational messages that highlight the progress of the application at coarse-grained level.|
| `debug` | Fatal, Error, Info, Warn, Debug | Designates fine-grained informational events that are most useful to debug an application.|
| `trace` | FatalAll levels | Traces the code execution between methods, lines, etc.|
| `off` | None | The highest possible rank and is intended to turn off logging.|
